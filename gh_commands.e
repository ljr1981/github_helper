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
	GH_ANY

	FW_PROCESS_HELPER

feature -- Access

	command_path: detachable PATH
			-- `command_path'.

	attached_command_path: attached like command_path
			-- `attached_command_path' as attached versin of `command_path'.
		do
			check has_command_path: attached command_path as al_path then Result := al_path end
		end

	last_command_results: detachable STRING
			-- `last_command_results'.

	attached_command_results: STRING
			-- `attached_command_results' attached version of `last_command_results'.
		do
			check has_results: attached last_command_results as al_results then
				Result := al_results
			end
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

	is_git_exe_available: BOOLEAN
			-- `is_git_exe_available' for running git commands?
		do
			Result := git_exe_is_found_by_DOS_where or attached last_git_exe_path
		end

	git_exe_is_found_by_DOS_where: BOOLEAN
			-- `git_exe_is_found_by_DOS_where'?
		do
			Result := has_file_in_path ("git.exe")
		end

	is_clean_working_directory: BOOLEAN
			-- `is_clean_working_directory'?
		do
			check attached last_command_results as al_results then
				Result := al_results.has_substring (clean_message)
			end
		end

	has_local_git_changes: BOOLEAN
			-- `has_local_git_changes'.
		do
			Result := not is_clean_working_directory
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
			check attached last_command_results as al_results then
				Result := not al_results.is_empty
			end
		end

feature -- Basic Operations

	set_git_exe_path
			-- `set_git_exe_path'.
--		require
--			not_has_git_exe: not is_git_exe_available
		local
			l_env: EXECUTION_ENVIRONMENT
			l_value: STRING
			l_dir: DIRECTORY
			l_path: PATH
			l_exception: EXCEPTION
			l_scanner: GH_GIT_EXE_SCANNER
				-- List
			l_list: LIST [STRING]
			l_line,
			l_output: STRING
		do
			if is_git_exe_available then
				l_output := output_of_command ("where git.exe", "")
				l_list := l_output.split ('%N')
				l_line := l_list [1]
				l_line.replace_substring_all ("\git.exe%R", "")
				create last_git_exe_path.make_from_string (l_line)
			else
				create l_env
				if attached l_env.starting_environment.at ("LOCALAPPDATA") as al_local_appdata_path_string then
					create l_path.make_from_string (al_local_appdata_path_string + "\Github")
					create l_dir.make_with_path (l_path)
					if l_dir.exists then
						create l_scanner
						l_scanner.scan_path (l_path, 0)
						if attached l_scanner.last_git_exe_path as al_path then
	--						output_of_command ("SET PATH=%%PATH%%;" + al_path.name.out, "").do_nothing
							last_git_exe_path := al_path
						else
							create l_exception
							l_exception.set_description ("Missing LOCALAPPDATA Github git.exe file. Ensure Github Desktop App is installed.")
							l_exception.raise
						end
					else
						create l_exception
						l_exception.set_description ("Missing LOCALAPPDATA Github folder. Ensure Github Desktop App is installed.")
						l_exception.raise
					end
				else
					create l_exception
					l_exception.set_description ("Missing LOCALAPPDATA Environment Varaible.")
					l_exception.raise
				end
			end
		ensure
			has_git_exe: is_git_exe_available
		end

	github_status
		require
			has_git_exe: is_git_exe_available
		do
			last_command_results := Void
			last_command_results := output_of_command (attached_last_git_exe_path.name.out + "\git status", attached_command_path.name.out)
		end

	git_add (a_file_path: PATH)
		require
			has_git_exe: is_git_exe_available
		do
			last_command_results := Void
			last_command_results := output_of_command (attached_last_git_exe_path.name.out + "\git add " + a_file_path.name.out, attached_command_path.parent.name.out)
		end

	git_reset_hard
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
		require
			has_git_exe: is_git_exe_available
		do
			last_command_results := Void
			last_command_results := output_of_command (attached_last_git_exe_path.name.out + "\git reset --hard", attached_command_path.name.out)
		end

	git_pull
		note
			spec: "git pull [options] [<repository> [<refspec>…​]]"
			EIS: "src=https://git-scm.com/docs/git-pull"
		require
			has_git_exe: is_git_exe_available
		local
			l_options,
			l_repository,
			l_repository_spec: STRING
		do
			create l_options.make_empty
			create l_repository.make_empty
			create l_repository_spec.make_empty
			last_command_results := Void
			last_command_results := output_of_command (attached_last_git_exe_path.name.out + "\git pull " + l_options + l_repository + l_repository_spec, attached_command_path.name.out)
		end

	git_fetch_dry_run
			-- `git_fetch_dry_run'
		note
			spec: "git fetch --dry-run"
			EIS: "src=https://git-scm.com/docs/git-fetch"
		require
			has_git_exe: is_git_exe_available
		do
			last_command_results := Void
			last_command_results := output_of_command (attached_last_git_exe_path.name.out + "\git fetch --dry-run", attached_command_path.name.out)
		end

feature {TEST_SET_HELPER} -- Implementation

	parse_github_status (a_message: STRING)
			-- `parse_github_status' of `a_message'.
		do
			across
				a_message.split ('%N') as ic_list
			loop

			end
		end

feature {TEST_SET_HELPER} -- Implementation: Constants

	attached_last_git_exe_path: PATH
			-- `attached_last_git_exe_path' version of `last_git_exe_path'.
		once
			check has_exe_path: attached last_git_exe_path as al_path then Result := al_path end
		end

	last_git_exe_path: detachable PATH
			-- The `last_git_exe_path' computed.

	clean_message: STRING = "nothing to commit, working tree clean"
			-- `clean_message' = "nothing to commit, working tree clean".

end
