json.data @classes do |school_class|
  json.id school_class.id
  json.number school_class.number
  json.letter school_class.letter
  json.students_count school_class.students.size
end
