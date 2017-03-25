package audites.AuditorWindows

import org.uqbar.arena.windows.SimpleWindow
import audites.domain.Requirement
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Button

class NewRequirementWindow extends SimpleWindow<Requirement> {

	new(WindowOwner parent, Requirement model) {
		super(parent, model)
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
		
		
		
	}

}
