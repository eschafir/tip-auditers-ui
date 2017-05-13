package audites.AdminWindows

import audites.AdminWindows.NewOrEditUserWindow
import org.uqbar.arena.windows.WindowOwner
import audites.domain.User
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.Panel
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class NewUserWindow extends NewOrEditUserWindow {

	new(WindowOwner parent, User user) {
		super(parent, user)
	}

	override passwordLabel(Panel panel) {
		new Label(panel).text = "Contraseña"
		new PasswordField(panel) => [
			value <=> "passwordIngresed"
			width = 200
		]
	}

	override cancelCreateOrEdit() {
		modelObject.cancelCreation
	}

}
