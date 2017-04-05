package audites.Transformers

import org.uqbar.arena.bindings.ValueTransformer
import java.awt.Color

class RequirementStatusTransformer implements ValueTransformer<String, Object> {
	override getModelType() {
		typeof(String)
	}

	override getViewType() {
		typeof(Object)
	}

	override modelToView(String valueFromModel) {
		if(valueFromModel == "Completado") Color.GREEN else Color.ORANGE
	}

	override viewToModel(Object valueFromView) {
		null
	}
}
