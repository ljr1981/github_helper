note
	description: "[
		Abstract notion of {GH_COMMANDS}.
		]"
	design: "[
		Github commands are here to assist you with
		accessing Git commands and also Github through
		code to obtain specifications on status and to
		even control the process programmatically.
		]"

deferred class
	GH_COMMANDS

inherit
	FW_PROCESS_HELPER

feature -- Access

	command_path: detachable PATH
			-- `command_path'.

	attached_command_path: attached like command_path
			-- `attached_command_path' as attached versin of `command_path'.
		do
			check has_command_path: attached command_path as al_path then Result := al_path end
		end



feature -- Settings

	set_command_path (a_command_path: attached like command_path)
			-- `set_command_path' with `a_command_path'.
		do
			command_path := a_command_path
		ensure
			set: command_path ~ a_command_path
		end

feature -- Basic Operations

	github_status: STRING
		do
			Result := output_of_command ("git status", attached_command_path.name.out)
		end

feature {TEST_SET_HELPER} -- Implementation

	parse_github_status (a_message: STRING)
			-- `parse_github_status' of `a_message'.
		local
			l_list: LIST [STRING]
		do
			l_list := a_message.split ('%N')
			across
				l_list as ic_list
			loop

			end
		end

end
