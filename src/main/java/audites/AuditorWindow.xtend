package audites

import audites.appModel.AuditorAppModel
import audites.appModel.MainApplicationAppModel
import audites.appModel.NewRevisionAppModel
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import audites.AuditorWindows.NewRevisionWindow
import org.uqbar.arena.bindings.PropertyAdapter
import audites.domain.Revision
import org.uqbar.arena.widgets.List
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import audites.AuditorWindows.EditRevisionWindow
import audites.domain.User
import org.uqbar.arena.widgets.Label
import audites.AuditorWindows.CheckRevisionWindow

class AuditorWindow extends SimpleWindow<AuditorAppModel> {

	new(WindowOwner parent, User user) {
		super(parent, new AuditorAppModel(user))
		this.taskDescription = "Panel de Auditores"
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
		this.title = "Auditers"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		val panelButtons = new Panel(mainPanel)
		panelButtons.layout = new HorizontalLayout

		new Label(mainPanel).text = "Revisiones generadas"
		new List<Revision>(mainPanel) => [
			value <=> "revisionSelected"
			(items.bindToProperty("userLoged.revisions")).adapter = new PropertyAdapter(Revision, "name")
			height = 150
			width = 250
		]

		val options = new Panel(mainPanel).layout = new HorizontalLayout

		new Button(options) => [
			caption = "Nueva"
			onClick[|
				this.close
				new NewRevisionWindow(this, new NewRevisionAppModel(this.modelObject.userLoged)).open

			]
		]

		new Button(options) => [
			caption = "Ver"
			enabled <=> "revisionIsSelectedAuditor"
			onClick[|
				new CheckRevisionWindow(this, this.modelObject.revisionSelected, this.modelObject.userLoged).open
			]
		]

		new Button(options) => [
			caption = "Editar"
			enabled <=> "revisionIsNotFinished"
			onClick[|
				new EditRevisionWindow(this, this.modelObject.revisionSelected).open
			]
		]
	}

}
