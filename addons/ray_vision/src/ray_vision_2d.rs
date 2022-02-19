use gdnative::{
	prelude::*,
	api::{
		Node,
		Node2D,
		KinematicBody2D,
		Physics2DDirectSpaceState,
		World2D
	}
};

#[derive(NativeClass)]
#[inherit(Node2D)]
struct RayVision2D {
	#[property]
	angle_between_rays: f32,
	#[property]
	distance: f32,
	#[property]
	field_of_view: f32,
	#[property]
	hit_points: Vector2Array,
	current_detected_objects: Dictionary,
	previous_detected_objects: Dictionary,
	parent: Ref<KinematicBody2D>,
	side_rays_amount: i32,
	space_state: Ref<Physics2DDirectSpaceState>
}

fn get_space_state(owner: TRef<Node2D>) -> Ref<Physics2DDirectSpaceState> {
	let world_2d_ref = owner.get_world_2d().unwrap();
	let world_2d = unsafe { world_2d_ref.assume_safe() };
	let space_state = world_2d.direct_space_state().unwrap();
	space_state
}

#[methods]
impl RayVision2D {
	fn new(owner: TRef<Node2D>) -> Self {
		// let world_2d: TRef<World2D> = unsafe {
		// 	let reference = owner.get_world_2d().unwrap();
		// 	reference.assume_safe()
		// };
		// let space_state = world_2d.direct_space_state().unwrap();
		let parent: KinematicBody2D = owner.get_parent().unwrap();

		Self {
			angle_between_rays: 0.0,
			distance: 0.0,
			field_of_view: 0.0,
			hit_points: Vector2Array::new(),
			current_detected_objects: Dictionary::new_shared(),
			previous_detected_objects: Dictionary::new_shared(),
			parent,
			side_rays_amount: 0,
			space_state: get_space_state(owner)
		}
	}

	fn register_result(result: Dictionary) {

	}

	fn cast_ray(&self, angle: f64, owner: TRef<Node2D>) {
		let global_position = owner.global_position();
		let sum = (angle + owner.global_rotation()) as f32;
		let direction = Vector2::new(sum.cos(), sum.sin()).normalize()
			* self.distance + global_position;

		let space_state = unsafe { self.space_state.assume_safe() };
		let parent = unsafe { self.parent.assume_safe() };
		let mut exclude = VariantArray::new_shared();
		exclude.push(owner);

		let result = space_state.intersect_ray(
			global_position,
			direction,
			exclude,
			parent.collision_mask(),
			true,
			false
		);

		if result.is_empty() {
			return
		}

		self.register_result(result);
	}

	#[export]
	fn _physics_process(&mut self, owner: TRef<Node2D>) {
		self.current_detected_objects = Dictionary::new_shared();
		self.hit_points = Vector2Array::new();
		self.space_state = get_space_state(owner);
	}
}
