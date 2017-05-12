package audites.AdminWindows

import audites.AdminWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.NewOrEditUserAppModel
import audites.domain.Department
import audites.domain.Role
import audites.domain.User
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class NewOrEditUserWindow extends DefaultWindow<NewOrEditUserAppModel> {

	new(WindowOwner parent, User user) {
		super(parent, new NewOrEditUserAppModel(user))
	}

	new(WindowOwner parent, User user, User toEdit) {
		super(parent, new NewOrEditUserAppModel(user, toEdit))
	}

	override createWindowToFormPanel(Panel panel) {

		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		new Label(panel) => [
			text = "Nuevo Usuario"
			fontSize = 15
		]

		new Label(panel).text = "User ID"
		new TextBox(panel) => [
			value <=> "user.username"
			width = 200
		]

		new Label(panel).text = "Contraseña"
		new PasswordField(panel) => [
			value <=> "passwordIngresed"
			width = 200
		]

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
//			enabled <=> "departmentIngresed"
			onClick[|
				modelObject.createUser
				modelObject.addDepartment
			]
		]

		new Button(panel) => [
			caption = "Eliminar"
//			enabled <=> "departmentIngresed"
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

	}

	override createButtonPanels(Panel panel) {

		new Button(panel) => [
			caption = "Aceptar"
			onClick[|
				modelObject.saveOrUpdate()
				this.close
				new AdminWindow(this, modelObject.userLoged).open
			]
		]

		new Button(panel) => [
			caption = "Atras"
			onClick[|
				this.close
				new AdminWindow(this, modelObject.userLoged).open
			]
		]
	}

}
