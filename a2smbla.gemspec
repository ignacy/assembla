# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{a2smbla}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ignacy Moryc"]
  s.date = %q{2010-02-03}
  s.description = %q{This gem provides access to assembla tickets, listing them, creating and modyfing}
  s.email = %q{imoryc@gmail.com}
  s.executables = ["ass", "a2smbla"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".gitignore",
     "README.md",
     "Rakefile",
     "VERSION",
     "a2smbla.gemspec",
     "bin/a2smbla",
     "bin/ass",
     "config_default.yml",
     "lib/a2smbla.rb",
     "lib/interpreter.rb",
     "lib/ticket.rb",
     "rdoc/classes/AssEmBlr.html",
     "rdoc/created.rid",
     "rdoc/files/README_md.html",
     "rdoc/files/lib/a2smbla_rb.html",
     "rdoc/fr_class_index.html",
     "rdoc/fr_file_index.html",
     "rdoc/fr_method_index.html",
     "rdoc/index.html",
     "rdoc/rdoc-style.css",
     "spec/a2smbla_spec.rb"
  ]
  s.homepage = %q{http://github.com/ignacy/a2smbla}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Command line access to assembla}
  s.test_files = [
    "spec/a2smbla_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

