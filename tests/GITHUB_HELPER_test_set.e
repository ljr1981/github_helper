note
	description: "Tests of {GITHUB_HELPER}."
	testing: "type/manual"

class
	GITHUB_HELPER_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	GH_CONSTANTS
		undefine
			default_create
		end

feature -- Test routines

	git_finder_test
		local
			l_mock: MOCK_COMMANDS
		do
			create l_mock
			l_mock.set_git_exe_path
		end

	basic_tests
			-- `abc_tests'
		local
			l_mock: MOCK_COMMANDS
		do
			create l_mock
			l_mock.set_command_path (mock_path.parent)
			l_mock.set_git_exe_path

				-- Ensure clean ...
			l_mock.git_reset_hard
			assert_strings_equal ("hard_reset", hard_reset, l_mock.attached_command_results.substring (1, hard_reset.count))
			l_mock.github_status
			assert_strings_equal ("has_output", git_status_up_to_date, l_mock.attached_command_results)
			assert_integers_equal ("no_error", 0, l_mock.last_error)
			l_mock.github_status
			assert_booleans_equal ("clean", True, l_mock.is_clean_working_directory)

				-- File deleting ...
			delete_directory_content (mock_deleted_file_1.parent)
			l_mock.github_status
			assert_strings_equal ("deleted_1_and_2", deleted_1_and_2, l_mock.attached_command_results)
			l_mock.git_reset_hard
			assert_strings_equal ("hard_reset", hard_reset, l_mock.attached_command_results.substring (1, hard_reset.count))

				-- File modifying ...

				-- File adding ...
--			make_add_file_1
--			assert_strings_equal ("has_added_1", has_added_1, l_mock.github_status)
--			assert_strings_equal ("added_1", "", l_mock.git_add (mock_add_file_1))
--			delete_directory_content (mock_add_file_1.parent)

				-- Cleanup ...
			l_mock.git_reset_hard
			assert_strings_equal ("hard_reset", hard_reset, l_mock.attached_command_results.substring (1, hard_reset.count))
		end

feature {NONE} -- Implementation: Mocks

	git_status_up_to_date: STRING = "[
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean

]"

	has_added_1: STRING = "[
On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	files/files_added/

nothing added to commit but untracked files present (use "git add" to track)

]"

	deleted_1_and_2: STRING = "[
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	deleted:    files/files_deleted/delete_me_1.txt
	deleted:    files/files_deleted/delete_me_2.txt

no changes added to commit (use "git add" and/or "git commit -a")

]"

	hard_reset: STRING = "HEAD is now at"

feature {NONE} -- Implementation: Files

	mock_files_path: PATH
			-- `mock_files_path' = "..\ig_test_project\files"
		do
			create Result.make_from_string (mock_path.parent.name.out + "\files")
		end

	mock_files_added_path: PATH
			-- `mock_files_added_path' = "..\ig_test_project\files\files_added"
		do
			create Result.make_from_string (mock_path.parent.name.out + "\files\files_added")
		end

	mock_add_file_1: PATH
			-- `mock_add_file_1' = "..\ig_test_project\files\files_added\added_file_1.txt"
		note
			design: "[
				This file does NOT exist on the file system until it is created by this test
				set. Even then, it is created, tested for, and then deleted and removed from
				the repository.
				]"
		do
			create Result.make_from_string (mock_files_added_path.name.out + "\added_file_1.txt")
		end

	mock_add_file_2: PATH
			-- `mock_add_file_2' = "..\ig_test_project\files\files_added\added_file_2.txt"
		note
			design: "[
				This file does NOT exist on the file system until it is created by this test
				set. Even then, it is created, tested for, and then deleted and removed from
				the repository.
				]"
		do
			create Result.make_from_string (mock_files_added_path.name.out + "\added_file_2.txt")
		end

	mock_files_deleted_path: PATH
			-- `mock_files_deleted_path' = "..\ig_test_project\files\files_deleted"
		do
			create Result.make_from_string (mock_path.parent.name.out + "\files\files_deleted")
		end

	mock_deleted_file_1: PATH
			-- `mock_deleted_file_1' = "..\ig_test_project\files\files_added\deleted_file_1.txt"
		do
			create Result.make_from_string (mock_files_deleted_path.name.out + "\deleted_file_1.txt")
		end

	mock_deleted_file_2: PATH
			-- `mock_deleted_file_2' = "..\ig_test_project\files\files_added\deleted_file_2.txt"
		do
			create Result.make_from_string (mock_files_deleted_path.name.out + "\deleted_file_2.txt")
		end

	mock_files_modified_path: PATH
			-- `mock_files_modified_path' = "..\ig_test_project\files\files_modified"
		do
			create Result.make_from_string (mock_path.parent.name.out + "\files\files_modified")
		end

	mock_modified_file_1: PATH
			-- `mock_modified_file_1' = "..\ig_test_project\files\files_added\modified_file_1.txt"
		do
			create Result.make_from_string (mock_files_modified_path.name.out + "\modified_file_1.txt")
		end

	mock_modified_file_2: PATH
			-- `mock_modified_file_2' = "..\ig_test_project\files\files_added\modified_file_2.txt"
		do
			create Result.make_from_string (mock_files_modified_path.name.out + "\modified_file_2.txt")
		end

feature {NONE} -- Implementation: Basic Operations

	make_add_file_1
			-- `make_add_file_1'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (mock_add_file_1.name.out)
			l_file.put_string ("added_text")
			l_file.flush
			l_file.close
		end

	delete_directory_content (a_path: PATH)
			-- `delete_directory_content' at `a_path'.
		do
			(create {DIRECTORY}.make_with_path (a_path)).delete_content
		end

feature {NONE} -- Implementation: Constants

	mock_path: PATH
		do
			create Result.make_from_string (github_path.name + "\ig_test_project\ig_test_project.ecf")
		end

end
