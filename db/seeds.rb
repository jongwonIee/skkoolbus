# [
#     [1,1,1,1,1,1,1,1,1,1],
#     [1,1,1,1,1,1,1,1,1,1],
#     [1,1,1,1,1,1,1,1,1,1],
#
# ].each do |x|
#   Bus.create(s1: x[0], s2: x[1], s3: x[2], s4: x[3], s5: x[4], s6: x[5], s7: x[6], s8: x[7], s9: x[8], s10: x[9])
# end

Message.destroy_all

puts "Inserting message data.."
File.read("db/seed_data/msg.csv").split("\n").each do |line|
  data = line.strip.split("\t")
  Message.create(
      id: data[0],
      name: data[1],
      lang: 0
  )
end

# puts "Inserting en_message data.."
# File.read("db/seed_data/msg_en.csv").split("\n").each do |line|
#   data = line.strip.split("\t")
#   Message.create(
#       id: data[0],
#       name: data[1],
#       lang: 1
#   )
# end