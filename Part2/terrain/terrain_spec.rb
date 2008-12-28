require 'terrain'

describe Terrain do
	it "should be able to return its width" do
		ter = Terrain.new(1,2)
		ter.width.should eql(1)
	end
	
	it "should be able to return its length" do
		ter = Terrain.new(1,2)
		ter.length.should eql(2)
	end
	
	it "should be able to set its height at a position" do # test done to check that there are no errors in the function
		ter = Terrain.new(1,2)
		ter.setHeight(1,1,5)
	end
	
	it "should be able to return its height at a position" do
		ter = Terrain.new(1,2)
		ter.getHeight(1,1).should eql(nil) # maybe it should be zero not nil...
	end
	
	it "should keep the height it has at a position" do
		ter = Terrain.new(1,2)
		ter.setHeight(1,1,5)
		ter.getHeight(1,1).should eql(5)
	end
	
	it "should be able to compute it's normals"
	it "should be able to return the normal at a postition"
end

describe Vec3f do
		it "should return the indecies" do
			vec = Vec3f.new(1, 2, 3)
			vec[0].should eql(1)
			vec[1].should eql(2)
			vec[2].should eql(3)
		end
		
		it "should be able to be multiplied by a scale" do
			vec = Vec3f.new(1,2,3)
			vec2 = vec * 2
			vec2[0].should eql(2)
			vec2[1].should eql(4)
			vec2[2].should eql(6)
		end
		
		it "should be able to be divided by a scale" do
			vec = Vec3f.new(1,2,3)
			vec2 = vec / 2.0
			vec2[0].should eql(0.5)
			vec2[1].should eql(1.0)
			vec2[2].should eql(1.5)
		end
		
		it "should be able to have another Vec3f object added to it" do
			vec = Vec3f.new(1,2,3)
			vec2 = Vec3f.new(1,2,3)
			vec3 = vec + vec2
			vec3[0].should eql(2)
			vec3[1].should eql(4)
			vec3[2].should eql(6)
		end
		
		it "should be able to have another Vec3f object subtracted from it" do
			vec = Vec3f.new(4,10,33)
			vec2 = Vec3f.new(1,2,3)
			vec3 = vec - vec2
			vec3[0].should eql(3)
			vec3[1].should eql(8)
			vec3[2].should eql(30)
		
		end
		it "should be able to return a Vec3f object that is negative itself" do
			vec = Vec3f.new(1,2,3)
			vec2 = -vec
			vec2[0].should eql(-1)
			vec2[1].should eql(-2)
			vec2[2].should eql(-3)
		end
		
		it "should be able to use the *= operator" do
			vec = Vec3f.new(1,2,3)
			vec *= 2
			vec[0].should eql(2)
			vec[1].should eql(4)
			vec[2].should eql(6)
		end
		
		it "should be able to use the /= operator" do
			vec = Vec3f.new(2,4,6)
			vec /= 2
			vec[0].should eql(1)
			vec[1].should eql(2)
			vec[2].should eql(3)
		end
		
		it "should be able to use the += operator" do
			vec = Vec3f.new(1,2,3)
			vec2 = Vec3f.new(1,2,3)
			vec += vec2
			vec[0].should eql(2)
			vec[1].should eql(4)
			vec[2].should eql(6)
		end
		
		it "should be able to use the -= operator" do
			vec = Vec3f.new(2,4,6)
			vec2 = Vec3f.new(1,2,3)
			vec -= vec2
			vec[0].should eql(1)
			vec[1].should eql(2)
			vec[2].should eql(3)
		end
		
		it "should be able to return its magnitude" do
			vec = Vec3f.new(1,2,3)
			vec.magnitude.should eql(Math.sqrt((1**2) + (2 ** 2) + (3 ** 2)))
		end
		
		it "should be able to return its magnitude squared" do
			vec = Vec3f.new(1,2,3)
			vec.magnitudeSquared.should eql((1**1) + (2 ** 2) + (3 ** 2))
		end
		
		it "should be able to normalize itself" do # This test is probably bad coding/testing practice, but I don't want to do the math myself 
			vec = Vec3f.new(1,2,3)
			m = vec.magnitude
			vec2 = Vec3f.new(vec[0] / m, vec[1] / m, vec[2] / m)
			
			vec3 = vec.normalize
			vec3[0].should eql(vec2[0])
			vec3[1].should eql(vec2[1])
			vec3[2].should eql(vec2[2])
		end
		
		it "should be able to dot itself" do
			vec = Vec3f.new(1,2,3)
			vec2 = Vec3f.new(1,2,3)
			dotted = vec.dot(vec2)
			dotted.should eql((1*1) + (2*2) + (3*3))
		end
		
		it "should be able to cross itself" do
			vec = Vec3f.new(1,2,3)
			vec2 = Vec3f.new(4,5,6)
			vec3 = vec.cross(vec2)
			vec3[0].should eql(-3)
			vec3[1].should eql(6)
			vec3[2].should eql(-3)
		end
		it "should be able to put its information in text format" do
			vec = Vec3f.new(1,2,3)
			vec.to_s.should eql("(1,2,3)")
		end
end