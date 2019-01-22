require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students
                       id INTEGER PRIMARY KEY,
                       name TEXT,
                       grade TEXT
                     ")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(info_arr)
    self.new(row[0], row[1], row[2])
  end

  def find_by_name(name)
    DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).map {|row| self.new_from_db(row)}.first
  end

end
