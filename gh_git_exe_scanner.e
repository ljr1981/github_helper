note
	description: "Summary description for {GH_GIT_EXE_SCANNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GH_GIT_EXE_SCANNER

inherit
	FW_PATH_SCANNER

feature -- Basic Operations

	handle_current_path (a_path: PATH; a_level: INTEGER)
			-- <Precursor>
		do
			if (create {DIRECTORY}.make_with_path (a_path)).has_entry ("git.exe") then
				last_git_exe_path := a_path
			end
			is_scan_down := not attached last_git_exe_path
		end

	last_git_exe_path: detachable PATH

end
