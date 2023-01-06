
use std::fs::OpenOptions;
use stl_io::{IndexedMesh, Triangle};

struct Components {
    mesh: IndexedMesh,
    v_of_v: Vec<Vec<usize>>,
    seen: Vec<bool>,
}

impl Components {
    fn new(mesh: IndexedMesh) -> Components {
        let seen = vec![false; mesh.vertices.len()];
        let mut v_of_v = vec![Vec::new(); mesh.vertices.len()];
        for t in &mesh.faces {
            for v in t.vertices {
                for w in t.vertices {
                    v_of_v[v].push(w);
                }
            }
        }
        Components{mesh, v_of_v, seen}
    }
    fn create(&mut self, start: usize) -> Vec<bool> {
        let mut component = vec![false; self.mesh.vertices.len()];
        let mut stack = Vec::new();
        self.seen[start] = true;
        component[start] = true;
        stack.push(start);
        self.seen[start] = true;
        while let Some(n) = stack.pop() {
            for &v in &self.v_of_v[n] {
                if !self.seen[v] {
                    self.seen[v] = true;
                    component[v] = true;
                    stack.push(v);
                }
            }
        }
        component
    }
    fn split(&mut self) -> Vec<Vec<bool>> {
        let mut components = Vec::new();
        for i in 0 .. self.seen.len() {
            if !self.seen[i] {
                let component = self.create(i);
                components.push(component);
            }
        }
        components
    }
    fn compress(&self, component: &Vec<bool>) -> Vec<Triangle> {
        let mut faces = Vec::new();
        for f in &self.mesh.faces {
            if component[f.vertices[0]] {
                faces.push(Triangle{
                    normal: f.normal,
                    vertices: [
                        self.mesh.vertices[f.vertices[0]],
                        self.mesh.vertices[f.vertices[1]],
                        self.mesh.vertices[f.vertices[2]],
                    ]});
            }
        }
        faces
    }
}

fn read_stl_file(path: &str) -> IndexedMesh {
    let mut file = OpenOptions::new().read(true).open(path).unwrap();
    stl_io::read_stl(&mut file).unwrap()
}

fn munge_path(path: &str, i: usize) -> String {
    let path = path.strip_suffix(".stl").unwrap_or(path);
    format!("{}_{}.stl", path, i)
}

fn main() {
    let path = std::env::args().nth(1).unwrap();
    let mesh = read_stl_file(&path);
    let mut components = Components::new(mesh);
    for (i, component) in components.split().iter().enumerate() {
        let mut count = 0;
        for &b in component {
            if b { count += 1; }
        }
        println!("{} -> {}", i, count);
        let submesh = components.compress(component);
        let subpath = munge_path(path.as_str(), i);
        let mut file = OpenOptions::new().write(true).create(true).open(subpath).unwrap();
        stl_io::write_stl(&mut file, submesh.iter()).unwrap();
    }
}
