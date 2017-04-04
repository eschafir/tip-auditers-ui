package audites.AuditorWindows

import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditRevisionWindow extends NewRevisionWindow {

	new(WindowOwner parent, Revision revision) {
		super(parent, new NewRevisionAppModel(revision))
		this.taskDescription = "Edita la revision " + this.modelObject.revisionName
	}

	override protected addActions(Panel actionsPanel) {

		new Button(actionsPanel) => [
			caption = "Cerrar"
			onClick[|
				this.close
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Audites"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		new Label(mainPanel).text = "Nombre de la revision"
		new TextBox(mainPanel) => [
			value <=> "revisionName"
		]

		new Label(mainPanel).text = "Descripcion"
		new TextBox(mainPanel) => [
			value <=> "revisionComment"
			multiLine = true
			height = 150
			width = 250
		]

		new Label(mainPanel).text = "Requerimientos"
		new List(mainPanel) => [
			value <=> "selectedRequirement"
			(items.bindToProperty("revision.requirements")).adapter = new PropertyAdapter(Revision, "name")
			height = 150
			width = 250
		]

		new Button(mainPanel) =>
			[
				caption = "Editar..."
				onClick[|
					new EditRequirementWindow(this, this.modelObject.revision, this.modelObject.selectedRequirement,
						this.modelObject.userLoged).open
				]
			]

	}

}
