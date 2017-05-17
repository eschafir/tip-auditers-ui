package audites.AdminWindows

import audites.domain.User
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.Button
import audites.AdminWindow

class NewUserWindow extends NewOrEditUserWindow {

	new(WindowOwner parent, User user) {
		super(parent, user)
	}

	override titleLabel(Panel panel) {
		new Label(panel) => [
			text = "Nuevo Usuario"
			fontSize = 15
		]
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

	override statusButton(Panel panel) {
	}

	override acceptButton(Panel panel) {
		new Button(panel) => [
			caption = "Aceptar"
			onClick[|
				modelObject.save()
				this.close
				new AdminWindow(this, modelObject.userLoged).open
			]
		]
	}

}
