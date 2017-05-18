package audites.AdminWindows

import audites.AdminWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.EditUserAppModel
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
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.layout.HorizontalLayout

class EditUserWindow extends DefaultWindow<EditUserAppModel> {

	new(WindowOwner parent, User user, User toEdit) {
		super(parent, new EditUserAppModel(user, toEdit))
	}

	override createWindowToFormPanel(Panel panel) {

		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		new Label(panel) => [
			text = "Editar Usuario"
			fontSize = 15
		]

		val useridPanel = new Panel(panel) => [layout = new HorizontalLayout]
		new Label(useridPanel) => [text = "User ID: "]
		new Label(useridPanel) => [text = modelObject.user.username]

		val namePanel = new Panel(panel) => [layout = new HorizontalLayout]
		new Label(namePanel).text = "Nombre Completo: "
		new Label(namePanel) => [value <=> "user.name"]
		new Button(namePanel) => [
			caption = "Editar..."
			onClick[|new EditUserName(this, modelObject.user, modelObject.user.name).open]
		]

		val emailPanel = new Panel(panel) => [layout = new HorizontalLayout]
		new Label(emailPanel).text = "Email: "
		new Label(emailPanel) => [value <=> "user.email"]
		new Button(emailPanel) => [
			caption = "Editar..."
			onClick[|new EditUserEmail(this, modelObject.user, modelObject.user.email).open]
		]

		new Label(panel).text = "Departamentos"

		new List<Department>(panel) => [
			value <=> "selectedDepartment"
			(items.bindToProperty("userDepartments")).adapter = new PropertyAdapter(Department, "name")
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
			(items.bindToProperty("userRoles")).adapter = new PropertyAdapter(Role, "name")
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

		new Button(panel) => [
			caption = "Restablecer contraseña"
			onClick[|new EditUserPassword(this, modelObject.user, modelObject.passwordIngresed).open]
		]

		statusButton(panel)

	}

	override createButtonPanels(Panel panel) {
		new Button(panel) => [
			caption = "Aceptar"
			onClick[|
				this.close
				new AdminWindow(this, modelObject.userLoged).open
			]
		]
	}

	def statusButton(Panel panel) {
		if (modelObject.user.enabled) {
			new Button(panel) => [
				caption = "Deshabilitar"
				fontSize = 10
				width = 140
				height = 40
				visible <=> "userIsEnabled"
				onClick[|
					modelObject.changeUserStatus
					this.close
					new EditUserWindow(this, modelObject.userLoged, modelObject.user).open
				]
			]
		} else {
			new Button(panel) => [
				caption = "Habilitar"
				fontSize = 10
				width = 140
				height = 40
				visible <=> "userIsDisabled"
				onClick[|
					modelObject.changeUserStatus
					this.close
					new EditUserWindow(this, modelObject.userLoged, modelObject.user).open
				]
			]
		}
	}

}
