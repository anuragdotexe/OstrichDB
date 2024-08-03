package engine

import "../../utils"
import "../config"
import "../const"
import "../types"
import "./data"
import "./data/metadata"
import "./security"
import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"


OST_RUN_SIGNIN :: proc() -> bool {
	//get the username input from the user
	buf: [1024]byte
	fmt.printfln("Please enter your username:")
	n, inputSuccess := os.read(os.stdin, buf[:])

	if inputSuccess != 0 {
		error1 := utils.new_err(
			.CANNOT_READ_INPUT,
			utils.get_err_msg(.CANNOT_READ_INPUT),
			#procedure,
		)
		utils.throw_err(error1)
	}


	userName := strings.trim_right(string(buf[:n]), "\r\n")
	userNameFound := data.OST_READ_RECORD_VALUE(
		const.SEC_FILE_PATH,
		const.SEC_CLUSTER_NAME,
		userName,
	)
	if (userNameFound != userName) {
		error2 := utils.new_err(
			.ENTERED_USERNAME_NOT_FOUND,
			utils.get_err_msg(.ENTERED_USERNAME_NOT_FOUND),
			#procedure,
		)
		utils.throw_err(error2)
		fmt.printfln("The entered username was not found within OstrichDB. Please try again.")
		return false
	}

	//PRE-MESHING START=======================================================================================================
	//get the salt from the cluster that contains the entered username
	salt := data.OST_READ_RECORD_VALUE(const.SEC_FILE_PATH, const.SEC_CLUSTER_NAME, "salt")
	//get the value of the hash that is currently stored in the cluster that contains the entered username
	providedHash := data.OST_READ_RECORD_VALUE(const.SEC_FILE_PATH, const.SEC_CLUSTER_NAME, "hash")
	pHashAsBytes := transmute([]u8)providedHash


	preMesh := OST_MESH_SALT_AND_HASH(salt, pHashAsBytes)
	//PRE-MESHING END=========================================================================================================
	algoMethod := data.OST_READ_RECORD_VALUE(
		const.SEC_FILE_PATH,
		const.SEC_CLUSTER_NAME,
		"store_method",
	)
	//POST-MESHING START=======================================================================================================

	//get the password input from the user
	fmt.printfln("Please enter your password:")
	libc.system("stty -echo")
	n, inputSuccess = os.read(os.stdin, buf[:])
	if inputSuccess != 0 {
		error3 := utils.new_err(
			.CANNOT_READ_INPUT,
			utils.get_err_msg(.CANNOT_READ_INPUT),
			#procedure,
		)
		utils.throw_err(error3)
		return false
	}
	enteredPassword := strings.trim_right(string(buf[:n]), "\r\n")
	libc.system("stty echo")
	//conver the return algo method string to an int
	algoAsInt := strconv.atoi(algoMethod)

	//using the hasing algo from the cluster that contains the entered username, hash the entered password
	newHash := security.OST_HASH_PASSWORD(enteredPassword, algoAsInt, true)
	encodedHash := security.OST_ENCODE_HASHED_PASSWORD(newHash)
	postMesh := OST_MESH_SALT_AND_HASH(salt, encodedHash)
	//POST-MESHING END=========================================================================================================


	authPassed := OST_CROSS_CHECK_MESH(preMesh, postMesh)

	switch authPassed {
	case true:
		OST_START_SESSION_TIMER()
		fmt.printfln("Auth Passed! User has been signed in!")
		types.USER_SIGNIN_STATUS = true
		userLoggedInValue := config.OST_READ_CONFIG_VALUE("OST_USER_LOGGED_IN")
		if userLoggedInValue == "false" {
			config.OST_TOGGLE_CONFIG("OST_USER_LOGGED_IN")
		}
		break
	case false:
		fmt.printfln("Auth Failed. Password was incorrect please try again.")
		types.USER_SIGNIN_STATUS = false
		os.exit(0)
	}
	return types.USER_SIGNIN_STATUS

}

//meshes the salt and hashed password , returns the mesh
// s- salt , hp- hashed password
OST_MESH_SALT_AND_HASH :: proc(s: string, hp: []u8) -> string {
	mesh: string
	hpStr := transmute(string)hp
	mesh = strings.concatenate([]string{s, hpStr})
	return mesh
}

//checks if the users information does exist in the user credentials file
//cn- cluster name, un- username, s-salt , hp- hashed password
OST_CROSS_CHECK_MESH :: proc(preMesh: string, postMesh: string) -> bool {
	if preMesh == postMesh {
		return true
	}

	return false
}

OST_USER_LOGOUT :: proc(param: int) -> bool {
	loggedOut := config.OST_TOGGLE_CONFIG("OST_USER_LOGGED_IN")

	switch loggedOut {
	case true:
		switch (param) 
		{
		case 0:
			types.USER_SIGNIN_STATUS = false
			fmt.printfln("You have been logged out.")
			OST_STOP_SESSION_TIMER()
			OST_START_ENGINE()
			break
		case 1:
			//only used when logging out AND THEN exiting.
			types.USER_SIGNIN_STATUS = false
			fmt.printfln("You have been logged out.")
			fmt.println("Now Exiting OstrichDB See you soon!\n")
			os.exit(0)
		}
		break
	case false:
		types.USER_SIGNIN_STATUS = true
		fmt.printfln("You have NOT been logged out.")
		break
	}
	return types.USER_SIGNIN_STATUS
}
