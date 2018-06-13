class Student

  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-HELLO
    CREATE TABLE IF NOT EXISTS students
    (id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER
    )
    HELLO

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-HELLO
    DROP TABLE IF EXISTS students
    HELLO
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-HELLO
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    HELLO
    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end



end
