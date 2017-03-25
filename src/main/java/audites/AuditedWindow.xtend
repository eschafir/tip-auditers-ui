package audites

import audites.appModel.AuditorAppModel
import audites.domain.Revision
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import audites.appModel.MainApplicationAppModel
import org.uqbar.arena.widgets.Button

class AuditedWindow extends SimpleWindow<AuditorAppModel> {

	new(WindowOwner parent, AuditorAppModel model) {
		super(parent, model)
		this.taskDescription = "Revisiones asignadas"
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
				new MainApplicationWindows(this, new MainApplicationAppModel(this.modelObject.userLoged)).open
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		new List<Revision>(mainPanel) => [
			value <=> "revisionSelected"
			(items.bindToProperty("userLoged.revisions")).adapter = new PropertyAdapter(Revision, "name")
			height = 150
		]
	}

}
