package audites.AuditorWindows

import audites.appModel.CheckRevisionAppModel
import audites.domain.Evidence
import audites.domain.Requirement
import java.awt.Desktop
import java.io.File
import org.uqbar.arena.aop.windows.TransactionalDialog
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Link
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner

class AttachtmentWindow extends TransactionalDialog<CheckRevisionAppModel> {

	new(WindowOwner parent, Requirement requirement) {
		super(parent, new CheckRevisionAppModel(requirement))
	}

	override createContents(Panel mainPanel) {
		createFormPanel(mainPanel)
		addActions(mainPanel)
	}

	override protected addActions(Panel actionsPanel) {
		val buttonsPanel = new Panel(actionsPanel)
		new Button(buttonsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		val desktop = Desktop.desktop
		for (Evidence e : this.modelObject.evidencesOfRequirementSelected) {
			new Link(mainPanel) => [
				caption = e.path
				onClick[|
					desktop.open(new File(e.completePath))
				]
			]
		}
	}
}
