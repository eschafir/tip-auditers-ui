package audites.AdminWindows

import audites.appModel.EditUserAppModel
import audites.domain.User
import org.apache.commons.codec.digest.DigestUtils
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.Window
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

abstract class EditUserPropertyWindow extends Window<EditUserAppModel> {

	new(WindowOwner parent, User user, Object object) {
		super(parent, new EditUserAppModel(user, object))
	}

	override createContents(Panel mainPanel) {

		new TextBox(mainPanel) => [
			value <=> "propertyToEdit"
		]

		val actionsButton = new Panel(mainPanel) => [layout = new HorizontalLayout]
		new Button(actionsButton) => [
			caption = "Aceptar"
			onClick[|
				changeProperty
				modelObject.update()
				this.close
			]
		]

		new Button(actionsButton) => [
			caption = "Cancelar"
			onClick[|this.close]
		]
	}

	abstract def void changeProperty()

}

class EditUserName extends EditUserPropertyWindow {

	new(WindowOwner parent, User user, Object object) {
		super(parent, user, object)
	}

	override changeProperty() {
		modelObject.user.name = modelObject.propertyToEdit.toString
	}
}

class EditUserEmail extends EditUserPropertyWindow {

	new(WindowOwner parent, User user, Object object) {
		super(parent, user, object)
	}

	override changeProperty() {
		modelObject.user.email = modelObject.propertyToEdit.toString
	}
}

class EditUserPassword extends EditUserPropertyWindow {

	new(WindowOwner parent, User user, Object object) {
		super(parent, user, object)
	}

	override changeProperty() {
		modelObject.user.password = DigestUtils.sha256Hex(modelObject.propertyToEdit.toString)
	}
}
