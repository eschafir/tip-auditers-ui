package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.GenerateOrEditReportAppModel
import audites.domain.Observation
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

class GenerateReportWindow extends DefaultWindow<GenerateOrEditReportAppModel> {

	new(WindowOwner parent, User user, Revision revision) {
		super(parent, new GenerateOrEditReportAppModel(user, revision))
	}

	override createWindowToFormPanel(Panel panel) {
		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		new Label(panel) => [
			text = "Reporte de " + modelObject.revision.name
			fontSize = 10
		]

		for (Observation obs : modelObject.report.observations) {
			new Label(panel) => [
				text = obs.requirement.name
				fontSize = 11
			]

			new TextBox(panel) => [
				multiLine = true
				height = 100
				width = 100
//				value <=> "comment"
			]
		}

	}

	override createButtonPanels(Panel panel) {
		new Button(panel) => [
			caption = "Aceptar"
			setAsDefault
			onClick[|
				modelObject.saveOrUpdateReport
				this.close
			]
		]
	}

}
