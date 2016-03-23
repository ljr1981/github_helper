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

feature -- Basic Operations

	github_status (a_path: PATH): STRING
		do
			Result := output_of_command ("git status", a_path.parent.name.out)
		end

end
