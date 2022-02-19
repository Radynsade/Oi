use gdnative::{
	prelude::*,
	api::{
		Node,
		Node2D,
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
	parent: Ref<Node>,
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
		let parent = owner.get_parent().unwrap();

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

	#[export]
	fn _physics_process(&mut self, owner: TRef<Node2D>) {
		self.current_detected_objects = Dictionary::new_shared();
		self.hit_points = Vector2Array::new();
		let world_2d_ref = unsafe { owner.get_world_2d().unwrap() };
		let world_2d = unsafe { world_2d_ref.assume_safe() };
		let space_state = unsafe { world_2d.direct_space_state().unwrap().assume_safe() };
	}
}
