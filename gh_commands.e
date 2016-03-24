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

feature -- Status Report

	is_clean_working_directory: BOOLEAN
			-- `is_clean_working_directory'?
		do
			Result := github_status.has_substring (clean_message)
		end

	has_remote_github_changes: BOOLEAN
			-- `has_remote_github_changes'?
			-- Presumes that an empty Result = no remote changes.
		note
			design: "[
				Presumes that an empty Result = no remote changes.
				]"
			example: "[
				This is how a non-empty fetch dry-run appears:
				----------------------------------------------
				remote: Counting objects: 4, done.
				remote: Compressing objects: 100% (3/3), done.
				remote: Total 4 (delta 1), reused 0 (delta 0), pack-reused 0
				Unpacking objects: 100% (4/4), done.
				From https://github.com/ljr1981/ig_test_project
				   6d42609..a7b2358  master     -> origin/master
				]"
		do
			Result := not git_fetch_dry_run.is_empty
		end

feature -- Basic Operations

	github_status: STRING
		do
			Result := output_of_command ("git status", attached_command_path.name.out)
		end

	git_add (a_file_path: PATH): STRING
		do
			print ("git add " + a_file_path.name.out)
			Result := output_of_command ("git add " + a_file_path.name.out, attached_command_path.parent.name.out)
		end

	git_reset_hard: STRING
			-- `git_reset_hard': Resets the index and working tree. Any changes to tracked
			-- files in the working tree since <commit> are discarded.
		note
			synopsis: "[
				Resets the index and working tree. Any changes to tracked 
				files in the working tree since <commit> are discarded.
				]"
			EIS: "src=https://git-scm.com/docs/git-reset"
			EIS: "name=fetch_and_merge_instead_of_pull",
					"src=http://longair.net/blog/2009/04/16/git-fetch-and-merge/"
		do
			Result := output_of_command ("git reset --hard", attached_command_path.name.out)
		end

	git_pull: STRING
		note
			spec: "git pull [options] [<repository> [<refspec>…​]]"
			EIS: "src=https://git-scm.com/docs/git-pull"
		local
			l_options,
			l_repository,
			l_repository_spec: STRING
		do
			create l_options.make_empty
			create l_repository.make_empty
			create l_repository_spec.make_empty
			Result := output_of_command ("git pull " + l_options + l_repository + l_repository_spec, attached_command_path.name.out)
		end

	git_fetch_dry_run: STRING
			-- `git_fetch_dry_run'
		note
			spec: "git fetch --dry-run"
			EIS: "src=https://git-scm.com/docs/git-fetch"
		do
			Result := output_of_command ("git fetch --dry-run", attached_command_path.name.out)
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

feature {TEST_SET_HELPER} -- Implementation: Constants

	clean_message: STRING = "nothing to commit, working directory clean"

end
