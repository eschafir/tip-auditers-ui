package audites.AuditorWindows

import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditRevisionWindow extends NewRevisionWindow {

	new(WindowOwner parent, Revision revision) {
		super(parent, new NewRevisionAppModel(revision))
	}

	override protected addActions(Panel actionsPanel) {
	}

	override protected createFormPanel(Panel mainPanel) {
		new TextBox(mainPanel) => [
			value <=> "revisionName"
		]

	}

}
