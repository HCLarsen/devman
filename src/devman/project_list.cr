class ProjectList
  YAML.mapping(
    projects: { type: Hash(String, Project), default: {} of String => Project }
  )

  def size : Int32
    @projects.size
  end

  def [](key : String)
    @projects[key]
  end

  # Raises an Error to prevent duping.
  def dup
    raise "Can't dup instance of singleton #{self.class}"
  end
end
