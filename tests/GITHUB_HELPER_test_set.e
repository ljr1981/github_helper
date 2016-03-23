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

	basic_tests
			-- `abc_tests'
		local
			l_mock: MOCK_COMMANDS
		do
			create l_mock
			l_mock.set_command_path (mock_path.parent)
			assert_strings_equal ("has_output", git_status_up_to_date, l_mock.github_status)
			assert_integers_equal ("no_error", 0, l_mock.last_error)
		end

feature {NONE} -- Implementation: Mocks

	git_status_up_to_date: STRING = "[
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean

]"

	git_status_new_files: STRING = "[
On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	git.txt
	test.txt

nothing added to commit but untracked files present (use "git add" to track)

]"

	git_status_changed_and_new_files: STRING = "[
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   tests/IG_TEST_PROJECT_test_set.e

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	git.txt
	test.txt

no changes added to commit (use "git add" and/or "git commit -a")

]"

	git_status_3: STRING = "[
On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

        files/

nothing added to commit but untracked files present (use "git add" to track)
]"

feature {NONE} -- Implementation: Constants

	mock_path: PATH
		do
			create Result.make_from_string (github_path.name + "\ig_test_project\ig_test_project.ecf")
		end

end
