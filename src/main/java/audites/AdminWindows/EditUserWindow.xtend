package audites.AdminWindows

import audites.domain.User
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner

class EditUserWindow extends NewOrEditUserWindow {

	new(WindowOwner parent, User user, User toEdit) {
		super(parent, user, toEdit)
	}

	override passwordLabel(Panel panel) {
	}

	override cancelCreateOrEdit() {
	}

}
