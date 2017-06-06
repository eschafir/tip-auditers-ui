package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.GenerateOrEditReportAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import audites.domain.Requirement

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
			text = modelObject.revision.report.name
			fontSize = 10
		]

		new Label(panel) => [
			text = modelObject.revision.report.requirements.size.toString
			fontSize = 10
		]
//		new TextBox(panel) => [
//			multiLine = true
//			height = 200
//			width = 500
//			value <=> "revision.report.observations"
//		]
		for (Requirement req : modelObject.revision.report.requirements) {
			new Label(panel) => [
				text = req.name
				fontSize = 11
			]

			new TextBox(panel) => [
				multiLine = true
				height = 100
				width = 100
				value <=> "revision.report.observations"
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
