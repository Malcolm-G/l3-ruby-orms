class Student
    attr_accessor :name, :age, :id

    def initialize(name:, age:, id: nil)
        @id=id
        @name=name
        @age=age
    end

# TODO: CREATE TABLE
def self.create_table
    query = <<-SQL
    CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY AUTOINCREMENT,name VARCHAR(169), age INTEGER NOT NULL)
    SQL

    DB[:conn].query(query)
end

# TODO: INSERT RECORD   
def create
    query = <<-SQL
    INSERT INTO students (name,age) VALUES (?,?)
    SQL

    DB[:conn].query(query,self.name,self.age)
    setup_id
end
# TODO: SHOW ALL RECORDS
def self.all
    query = <<-SQL
    SELECT * FROM students
    SQL

    DB[:conn].query(query).map do |row|
        convert_to_object row
    end
end

# TODO: UPDATE RECORD
def update
    query = <<-SQL
    UPDATE students SET name = ?, age = ?
    WHERE name = ?
    SQL

    DB[:conn].query(query,self.name,self.age,self.name)
end

# TODO: DELETE RECORD
def destroy
    query = <<-SQL
    DELETE FROM students WHERE name = ?
    SQL
    # HEREDOC
    DB[:conn].query(query,self.name)
end
# TODO: CONVERT TABLE RECORD TO RUBY OBJECT
def self.convert_to_object row
    self.new(id:row[0],name:row[1],age:row[2])
end

# reset table
def self.reset
    query = <<-SQL
    DROP TABLE IF EXISTS students
    SQL

    DB[:conn].query(query)
end

private

def setup_id
    query = <<-SQL
    SELECT last_insert_rowid() FROM students
    SQL
    self.id = DB[:conn].execute(query)[0][0]
end

# TODO: SEARCH FOR RECORD THAT MEETS CERTAIN CONDITIONS
def self.search_by (name:nil,age:nil)
    data = if name && age
        q = <<-SQL
        SELECT * FROM students WHERE name=? AND age =?
        SQL
        DB[:conn].query(q,name,age)
    elsif name
        q = <<-SQL
        SELECT * FROM students WHERE name=?
        SQL
        DB[:conn].query(q,name)
    elsif age
        q = <<-SQL
        SELECT * FROM students WHERE age=?
        SQL
        DB[:conn].query(q,age)
    else
        q = <<-SQL
        SELECT * FROM students
        SQL
        DB[:conn].query(q)
    end
    data.map do |row|
        convert_to_object(row)
    end
end
end
