package audites.Transformers

import org.uqbar.arena.bindings.ValueTransformer
import java.awt.Color

class AverageStatusTransformer implements ValueTransformer<Float, Object> {

	override getModelType() {
		typeof(Float)
	}

	override getViewType() {
		typeof(Object)
	}

	override modelToView(Float valueFromModel) {
		if(valueFromModel == 100.00) Color.GREEN else Color.ORANGE
	}

	override viewToModel(Object valueFromView) {
		null
	}

}
