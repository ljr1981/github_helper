note
	description: "[
		Abstract notion of {GH_CONSTANTS}
		]"
	design: "[
		A collection of system-wide constants.
		]"

deferred class
	GH_CONSTANTS

feature {TEST_SET_BRIDGE} -- Implementation: Constants

	Github_path: PATH
			-- `Github_path' from system.
		once
			create Result.make_from_string (github_path_string)
		end

	Github_path_string: STRING
			-- `Github_path_string' from {EXECUTION_ENVIRONMENT}.
		once
			Result := ".."
		end

	dot_git_string: STRING = ".git"
	dot_gitignore_string: STRING = ".gitignore"
	git_config_string: STRING = "config"
	EIFGENs_string: STRING = "EIFGENs"
	ecf_extension_string: STRING = "ecf"

	github_tag_string: STRING = ".."
	ise_library_tag_string: STRING = "$ISE_LIBRARY"
	ise_eiffel_tag_string: STRING = "$ISE_EIFFEL"
	ise_eiffel_environment_variable: STRING = "C:\Program Files (x86)\Eiffel Software\EiffelStudio 15.12 GPL"
	ise_library_environment_variable: STRING = "C:\Program Files (x86)\Eiffel Software\EiffelStudio 15.12 GPL"

end
