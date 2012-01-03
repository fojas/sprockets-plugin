require "spec_helper"

describe Sprockets::Plugin do
  after :each do
    Sprockets::Plugin.send :class_variable_set, :@@plugins, nil
  end
  
  it "adds paths from plugins to newly created environments" do
    dir_1 = @sandbox.directory "plugin_1/assets"
    dir_2 = @sandbox.directory "plugin_2/assets"
    dir_3 = @sandbox.directory "plugin_3/assets"
    
    plugin_1 = Class.new Sprockets::Plugin
    plugin_1.append_path dir_1
    plugin_2 = Class.new Sprockets::Plugin
    plugin_2.append_path dir_2
    plugin_3 = Class.new Sprockets::Plugin
    plugin_3.append_path dir_3
    
    env = Sprockets::Environment.new
    env.paths.should == [dir_1, dir_2, dir_3].map(&:to_s)
  end
  
  it "adds a #append_plugin_paths method for adding paths from plugins" do
    dir_1 = @sandbox.directory "plugin_1/assets"
    dir_2 = @sandbox.directory "plugin_2/assets"
    dir_3 = @sandbox.directory "plugin_3/assets"
    
    plugin_1 = Class.new Sprockets::Plugin
    plugin_1.append_path dir_1
    
    env = Sprockets::Environment.new
    env.paths.should == [dir_1].map(&:to_s)
    
    plugin_2 = Class.new Sprockets::Plugin
    plugin_2.append_path dir_2
    plugin_3 = Class.new Sprockets::Plugin
    plugin_3.append_path dir_3
    
    env.append_plugin_paths
    env.paths.should == [dir_1, dir_2, dir_3].map(&:to_s)
  end
  
  describe ".append_path" do
    it "adds paths" do
      dir_1 = @sandbox.directory "plugin/assets/images"
      dir_2 = @sandbox.directory "plugin/assets/javascripts"
      dir_3 = @sandbox.directory "plugin/assets/stylesheets"
      
      plugin = Class.new Sprockets::Plugin
      plugin.append_path dir_1
      plugin.append_path dir_2
      plugin.append_path dir_3
      plugin.paths.should == [dir_1, dir_2, dir_3].map(&:to_s)
    end
    
    it "adds the paths relative to the plugin root" do
      dir_1 = @sandbox.directory "plugin/assets/images"
      dir_2 = @sandbox.directory "plugin/assets/javascripts"
      dir_3 = @sandbox.directory "plugin/assets/stylesheets"
      
      plugin = Class.new Sprockets::Plugin
      plugin.root @sandbox.join "plugin"
      plugin.append_path "assets/images"
      plugin.append_path "assets/javascripts"
      plugin.append_path "assets/stylesheets"
      plugin.paths.should == [dir_1, dir_2, dir_3].map(&:to_s)
    end
    
    it "only adds existing paths" do
      dir_1 = @sandbox.directory "plugin/assets/images"
      dir_2 = @sandbox.directory "plugin/assets/javascripts"
      dir_3 = @sandbox.join "plugin/assets/stylesheets"
      
      plugin = Class.new Sprockets::Plugin
      plugin.append_path dir_1
      plugin.append_path dir_2
      plugin.append_path dir_3
      plugin.paths.should == [dir_1, dir_2].map(&:to_s)
    end
  end
  
  describe ".appends_paths" do
    it "adds multiple paths at once" do
      dir_1 = @sandbox.directory "plugin/assets/images"
      dir_2 = @sandbox.directory "plugin/assets/javascripts"
      dir_3 = @sandbox.directory "plugin/assets/stylesheets"
      
      plugin = Class.new Sprockets::Plugin
      plugin.append_path dir_1, dir_2 ,dir_3
      plugin.paths.should == [dir_1, dir_2, dir_3].map(&:to_s)
    end
  end
  
  describe ".prepend_path" do
    it "adds paths" do
      dir_1 = @sandbox.directory "plugin/assets/images"
      dir_2 = @sandbox.directory "plugin/assets/javascripts"
      dir_3 = @sandbox.directory "plugin/assets/stylesheets"
      
      plugin = Class.new Sprockets::Plugin
      plugin.prepend_path dir_1
      plugin.prepend_path dir_2
      plugin.prepend_path dir_3
      plugin.paths.should == [dir_3, dir_2, dir_1].map(&:to_s)
    end
    
    it "adds the paths relative to the plugin root" do
      dir_1 = @sandbox.directory "plugin/assets/images"
      dir_2 = @sandbox.directory "plugin/assets/javascripts"
      dir_3 = @sandbox.directory "plugin/assets/stylesheets"
      
      plugin = Class.new Sprockets::Plugin
      plugin.root @sandbox.join "plugin"
      plugin.prepend_path "assets/images"
      plugin.prepend_path "assets/javascripts"
      plugin.prepend_path "assets/stylesheets"
      plugin.paths.should == [dir_3, dir_2, dir_1].map(&:to_s)
    end
    
    it "only adds existing paths" do
      dir_1 = @sandbox.directory "plugin/assets/images"
      dir_2 = @sandbox.directory "plugin/assets/javascripts"
      dir_3 = @sandbox.join "plugin/assets/stylesheets"
      
      plugin = Class.new Sprockets::Plugin
      plugin.prepend_path dir_1
      plugin.prepend_path dir_2
      plugin.prepend_path dir_3
      plugin.paths.should == [dir_2, dir_1].map(&:to_s)
    end
  end
  
  describe ".prepends_paths" do
    it "adds multiple paths at once" do
      dir_1 = @sandbox.directory "plugin/assets/images"
      dir_2 = @sandbox.directory "plugin/assets/javascripts"
      dir_3 = @sandbox.directory "plugin/assets/stylesheets"
      
      plugin = Class.new Sprockets::Plugin
      plugin.append_path dir_1
      plugin.prepend_paths dir_2 ,dir_3
      plugin.paths.should == [dir_2, dir_3, dir_1].map(&:to_s)
    end
  end
  
  describe ".root" do
    it "converts the given path to a Pathname object" do
      plugin_path = @sandbox.join "plugin"
      plugin = Class.new Sprockets::Plugin
      plugin.root plugin_path.to_s
      plugin.root.should be_an_instance_of(Pathname)
      plugin.root.should == plugin_path
    end
  end
  
  describe ".plugins" do
    it "returns all of the plugins" do
      plugin_1 = Class.new Sprockets::Plugin
      plugin_2 = Class.new Sprockets::Plugin
      plugin_3 = Class.new Sprockets::Plugin
      Sprockets::Plugin.plugins.should == [ plugin_1, plugin_2, plugin_3 ]
    end
  end
end
