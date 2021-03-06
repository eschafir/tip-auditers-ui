package audites.AdminWindows

import audites.AdminWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.NewUserAppModel
import audites.domain.Department
import audites.domain.Role
import audites.domain.User
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

abstract class NewOrEditUserWindow extends DefaultWindow<NewUserAppModel> {

	new(WindowOwner parent, User user) {
		super(parent, new NewUserAppModel(user))
	}

	new(WindowOwner parent, User user, User toEdit) {
		super(parent, new NewUserAppModel(user, toEdit))
	}

	override createWindowToFormPanel(Panel panel) {

		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		titleLabel(panel)

		new Label(panel).text = "User ID"
		new TextBox(panel) => [
			value <=> "user.username"
			width = 200
		]

		passwordLabel(panel)

		new Label(panel).text = "Nombre Completo"
		new TextBox(panel) => [
			value <=> "user.name"
			width = 200
		]

		new Label(panel).text = "Email"
		new TextBox(panel) => [
			value <=> "user.email"
			width = 200
		]

		new Label(panel).text = "Departamentos"

		new List<Department>(panel) => [
			value <=> "selectedDepartment"
			(items.bindToProperty("user.departments")).adapter = new PropertyAdapter(Department, "name")
			height = 50
			width = 200
		]

		new Selector(panel) => [
			width = 185
			allowNull(false)
			value <=> "selectorDepartment"
			(items.bindToProperty("departments")).adapter = new PropertyAdapter(Department, "name")
		]

		new Button(panel) => [
			caption = "Agregar"
			enabled <=> "isDepartmentIngresed"
			onClick[|
				modelObject.createUser
				modelObject.addDepartment
			]
		]

		new Button(panel) => [
			caption = "Eliminar"
			enabled <=> "isDepartmentSelected"
			onClick[|
				modelObject.removeDepartment
			]
		]

		new Label(panel).text = "Roles"

		new List<Department>(panel) => [
			value <=> "selectedRole"
			(items.bindToProperty("user.roles")).adapter = new PropertyAdapter(Role, "name")
			height = 50
			width = 200
		]

		new Selector(panel) => [
			width = 185
			allowNull(false)
			value <=> "selectorRole"
			(items.bindToProperty("roles")).adapter = new PropertyAdapter(Role, "name")
		]

		new Button(panel) => [
			caption = "Agregar"
			enabled <=> "isRoleIngresed"
			onClick[|
				modelObject.createUser
				modelObject.addRole
			]
		]

		new Button(panel) => [
			caption = "Eliminar"
			enabled <=> "isRoleSelected"
			onClick[|
				modelObject.removeRole
			]
		]

		statusButton(panel)

	}

	override createButtonPanels(Panel panel) {

		acceptButton(panel)

		new Button(panel) => [
			caption = "Cancelar"
			onClick[|
				this.close
				cancelCreateOrEdit()
				new AdminWindow(this, modelObject.userLoged).open
			]
		]
	}

	abstract def void acceptButton(Panel panel)

	abstract def void titleLabel(Panel panel)

	abstract def void passwordLabel(Panel panel)

	abstract def void statusButton(Panel panel)

	abstract def void cancelCreateOrEdit()

}
