package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.CheckRevisionAppModel
import audites.domain.Evidence
import audites.domain.Requirement
import java.awt.Desktop
import java.io.File
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Link
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner

class AttachtmentWindow extends DefaultWindow<CheckRevisionAppModel> {

	new(WindowOwner parent, Requirement requirement) {
		super(parent, new CheckRevisionAppModel(requirement))
	}

	override createButtonPanels(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Cerrar"
			onClick[|
				this.close
			]
		]
	}

	override createWindowToFormPanel(Panel mainPanel) {
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
