package audites.AuditorWindows

import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.bindings.PropertyAdapter

class EditRevisionWindow extends NewRevisionWindow {

	new(WindowOwner parent, Revision revision) {
		super(parent, new NewRevisionAppModel(revision))
		this.taskDescription = "Edita la revision " + this.modelObject.revisionName
	}

	override protected addActions(Panel actionsPanel) {
	}

	override protected createFormPanel(Panel mainPanel) {

		new Label(mainPanel).text = "Nombre de la revision"
		new TextBox(mainPanel) => [
			value <=> "revisionName"
		]

		new List(mainPanel) => [
			value <=> "selectedRequirement"
			(items.bindToProperty("revision.requirements")).adapter = new PropertyAdapter(Revision, "name")
			height = 150
			width = 250
		]

	}

}
