require 'benchmark'
require 'benchmark/memory'

def delete_file(filename)
    File.open(filename, 'r') do |f|
        File.delete(f)
    end
end

def delete_file_chunk(filename, chunks)
    (0...chunks).each do |file_num|
        File.open("#{filename}-#{file_num}", 'r') do |f|
            File.delete(f)
        end
    end
end

def file_open_write_v1(filename, mode, limit)
    str = ''
    (0...limit).each do |num|
        str += "#{num}\n" 
    end

    File.open(filename, mode) do |f| 
        f.write str
    end
end

def file_open_write_v2(filename, mode, limit)
    File.open(filename, mode) do |f| 
        (0...limit).each do |num|
            f.write "#{num}\n" 
        end
    end
end

def file_open_write_v2_1(filename, mode, limit)
    f = File.open(filename, mode)
    (0...limit).each do |num|
        f.write "#{num}\n" 
    end
    f.close
end

def file_open_write_v3(filename, mode, limit, chunks)
    limit_per_file = (limit / chunks.to_f).ceil

    (0...chunks).each do |file_num|
        File.open("#{filename}-#{file_num}", mode) do |f| 
            (0...limit_per_file).each do |num|
                f.write "#{num}\n" 
            end
        end
    end
end

def file_open_write_v3_1(filename, mode, limit)
    limit_per_file = (limit / 10.0).ceil

    File.open("#{filename}-#{0}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{1}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{2}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{3}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{4}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{5}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{6}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{7}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{8}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
    File.open("#{filename}-#{9}", mode) do |f| 
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
    end
end

def file_open_write_v3_2(filename, mode, limit, chunks)
    limit_per_file = (limit / chunks.to_f).ceil

    (0...chunks).each do |file_num|
        f = File.open("#{filename}-#{file_num}", mode)
        (0...limit_per_file).each do |num|
            f.write "#{num}\n" 
        end
        f.close
    end
end

# def file_read(filename)
#     File.read(filename)
# end

# def file_foreach_read(filename)
#     File.foreach(filename) { |line| }
# end

def mem_benchmark_with_new_file
    limit = 25000
    chunks = 100

    Benchmark.memory do |x|
        x.report("Write all lines to file at once, mode \"w\"") { file_open_write_v1('log1-w', 'w', limit) }
        x.report("Write all lines to file at once, mode \"a\"") { file_open_write_v1('log1-a', 'a', limit) }
        x.report("Write all lines to file at once, mode \"w+\"") { file_open_write_v1('log1-wp', 'w+', limit) }
        x.report("Write all lines to file at once, mode \"a+\"") { file_open_write_v1('log1-ap', 'a+', limit) }
        
        x.report("Iterate and write per line to file, mode \"w\"") { file_open_write_v2('log2-w', 'w', limit) }
        x.report("Iterate and write per line to file, mode \"a\"") { file_open_write_v2('log2-a', 'a', limit) }
        x.report("Iterate and write per line to file, mode \"w+\"") { file_open_write_v2('log2-wp', 'w+', limit) }
        x.report("Iterate and write per line to file, mode \"a+\"") { file_open_write_v2('log2-ap', 'a+', limit) }
        
        x.report("Iterate and write per line to file (manual), mode \"w\"") { file_open_write_v2_1('log2_1-w', 'w', limit) }
        x.report("Iterate and write per line to file (manual), mode \"a\"") { file_open_write_v2_1('log2_1-a', 'a', limit) }
        x.report("Iterate and write per line to file (manual), mode \"w+\"") { file_open_write_v2_1('log2_1-wp', 'w+', limit) }
        x.report("Iterate and write per line to file (manual), mode \"a+\"") { file_open_write_v2_1('log2_1-ap', 'a+', limit) }
        
        x.report("Iterate and write per line to file chunks, mode \"w\"") { file_open_write_v3('log3-w', 'w', limit, chunks) }
        x.report("Iterate and write per line to file chunks, mode \"a\"") { file_open_write_v3('log3-a', 'a', limit, chunks) }
        x.report("Iterate and write per line to file chunks, mode \"w+\"") { file_open_write_v3('log3-wp', 'w+', limit, chunks) }
        x.report("Iterate and write per line to file chunks, mode \"a+\"") { file_open_write_v3('log3-ap', 'a+', limit, chunks) }

        # x.report("Iterate and write per line to file chunks (hardcode), mode \"w\"") { file_open_write_v3_1('log3_1-w', 'w', limit) }
        # x.report("Iterate and write per line to file chunks (hardcode), mode \"a\"") { file_open_write_v3_1('log3_1-a', 'a', limit) }
        # x.report("Iterate and write per line to file chunks (hardcode), mode \"w+\"") { file_open_write_v3_1('log3_1-wp', 'w+', limit) }
        # x.report("Iterate and write per line to file chunks (hardcode), mode \"a+\"") { file_open_write_v3_1('log3_1-ap', 'a+', limit) }

        x.report("Iterate and write per line to file chunks (manual), mode \"w\"") { file_open_write_v3_2('log3_2-w', 'w', limit, chunks) }
        x.report("Iterate and write per line to file chunks (manual), mode \"a\"") { file_open_write_v3_2('log3_2-a', 'a', limit, chunks) }
        x.report("Iterate and write per line to file chunks (manual), mode \"w+\"") { file_open_write_v3_2('log3_2-wp', 'w+', limit, chunks) }
        x.report("Iterate and write per line to file chunks (manual), mode \"a+\"") { file_open_write_v3_2('log3_2-ap', 'a+', limit, chunks) }

        x.compare!
    end

    delete_file('log1-w')
    delete_file('log1-a')
    delete_file('log1-wp')
    delete_file('log1-ap')
    delete_file('log2-w')
    delete_file('log2-a')
    delete_file('log2-wp')
    delete_file('log2-ap')
    delete_file('log2_1-w')
    delete_file('log2_1-a')
    delete_file('log2_1-wp')
    delete_file('log2_1-ap')
    delete_file_chunk('log3-w', chunks)
    delete_file_chunk('log3-a', chunks)
    delete_file_chunk('log3-wp', chunks)
    delete_file_chunk('log3-ap', chunks)
    # delete_file_chunk('log3_1-w', chunks)
    # delete_file_chunk('log3_1-a', chunks)
    # delete_file_chunk('log3_1-wp', chunks)
    # delete_file_chunk('log3_1-ap', chunks)
    delete_file_chunk('log3_2-w', chunks)
    delete_file_chunk('log3_2-a', chunks)
    delete_file_chunk('log3_2-wp', chunks)
    delete_file_chunk('log3_2-ap', chunks)
end

def cpu_benchmark_with_new_file
    limit = 25000
    chunks = 100

    Benchmark.bm(59) do |x|
        x.report("Write all lines to file at once, mode \"w\"                      ") { file_open_write_v1('log1-w', 'w', limit) }
        x.report("Write all lines to file at once, mode \"a\"                      ") { file_open_write_v1('log1-a', 'a', limit) }
        x.report("Write all lines to file at once, mode \"w+\"                     ") { file_open_write_v1('log1-wp', 'w+', limit) }
        x.report("Write all lines to file at once, mode \"a+\"                     ") { file_open_write_v1('log1-ap', 'a+', limit) }

        x.report("Iterate and write per line to file, mode \"w\"                    ") { file_open_write_v2('log2-w', 'w', limit) }
        x.report("Iterate and write per line to file, mode \"a\"                    ") { file_open_write_v2('log2-a', 'a', limit) }
        x.report("Iterate and write per line to file, mode \"w+\"                   ") { file_open_write_v2('log2-wp', 'w+', limit) }
        x.report("Iterate and write per line to file, mode \"a+\"                   ") { file_open_write_v2('log2-ap', 'a+', limit) }

        x.report("Iterate and write per line to file (manual), mode \"w\"          ") { file_open_write_v2_1('log2_1-w', 'w', limit) }
        x.report("Iterate and write per line to file (manual), mode \"a\"          ") { file_open_write_v2_1('log2_1-a', 'a', limit) }
        x.report("Iterate and write per line to file (manual), mode \"w+\"         ") { file_open_write_v2_1('log2_1-wp', 'w+', limit) }
        x.report("Iterate and write per line to file (manual), mode \"a+\"         ") { file_open_write_v2_1('log2_1-ap', 'a+', limit) }

        x.report("Iterate and write per line to file chunks, mode \"w\"            ") { file_open_write_v3('log3-w', 'w', limit, chunks) }
        x.report("Iterate and write per line to file chunks, mode \"a\"            ") { file_open_write_v3('log3-a', 'a', limit, chunks) }
        x.report("Iterate and write per line to file chunks, mode \"w+\"           ") { file_open_write_v3('log3-wp', 'w+', limit, chunks) }
        x.report("Iterate and write per line to file chunks, mode \"a+\"           ") { file_open_write_v3('log3-ap', 'a+', limit, chunks) }

        # x.report("Iterate and write per line to file chunks (hardcode), mode \"w\" ") { file_open_write_v3_1('log3_1-w', 'w', limit) }
        # x.report("Iterate and write per line to file chunks (hardcode), mode \"a\" ") { file_open_write_v3_1('log3_1-a', 'a', limit) }
        # x.report("Iterate and write per line to file chunks (hardcode), mode \"w+\"") { file_open_write_v3_1('log3_1-wp', 'w+', limit) }
        # x.report("Iterate and write per line to file chunks (hardcode), mode \"a+\"") { file_open_write_v3_1('log3_1-ap', 'a+', limit) }

        x.report("Iterate and write per line to file chunks (manual), mode \"w\"   ") { file_open_write_v3_2('log3_2-w', 'w', limit, chunks) }
        x.report("Iterate and write per line to file chunks (manual), mode \"a\"   ") { file_open_write_v3_2('log3_2-a', 'a', limit, chunks) }
        x.report("Iterate and write per line to file chunks (manual), mode \"w+\"  ") { file_open_write_v3_2('log3_2-wp', 'w+', limit, chunks) }
        x.report("Iterate and write per line to file chunks (manual), mode \"a+\"  ") { file_open_write_v3_2('log3_2-ap', 'a+', limit, chunks) }
    end

    delete_file('log1-w')
    delete_file('log1-a')
    delete_file('log1-wp')
    delete_file('log1-ap')
    delete_file('log2-w')
    delete_file('log2-a')
    delete_file('log2-wp')
    delete_file('log2-ap')
    delete_file('log2_1-w')
    delete_file('log2_1-a')
    delete_file('log2_1-wp')
    delete_file('log2_1-ap')
    delete_file_chunk('log3-w', chunks)
    delete_file_chunk('log3-a', chunks)
    delete_file_chunk('log3-wp', chunks)
    delete_file_chunk('log3-ap', chunks)
    # delete_file_chunk('log3_1-w', chunks)
    # delete_file_chunk('log3_1-a', chunks)
    # delete_file_chunk('log3_1-wp', chunks)
    # delete_file_chunk('log3_1-ap', chunks)
    delete_file_chunk('log3_2-w', chunks)
    delete_file_chunk('log3_2-a', chunks)
    delete_file_chunk('log3_2-wp', chunks)
    delete_file_chunk('log3_2-ap', chunks)
end

def mem_benchmark_with_existing_file
    limit = 25000

    file_open_write_v2('log-w', 'w', limit)
    file_open_write_v2('log-a', 'a', limit)
    file_open_write_v2('log-wp', 'w+', limit)
    file_open_write_v2('log-ap', 'a+', limit)

    Benchmark.memory do |x|
        x.report("Iterate and write per line to existing file, mode \"w\"") { file_open_write_v2('log-w', 'w', limit) }
        x.report("Iterate and write per line to existing file, mode \"a\"") { file_open_write_v2('log-a', 'a', limit) }
        x.report("Iterate and write per line to existing file, mode \"w+\"") { file_open_write_v2('log-wp', 'w+', limit) }
        x.report("Iterate and write per line to existing file, mode \"a+\"") { file_open_write_v2('log-ap', 'a+', limit) }

        x.compare!
    end

    delete_file('log-w')
    delete_file('log-a')
    delete_file('log-wp')
    delete_file('log-ap')
end

def cpu_benchmark_with_existing_file
    limit = 25000

    file_open_write_v2('log-w', 'w', limit)
    file_open_write_v2('log-a', 'a', limit)
    file_open_write_v2('log-wp', 'w+', limit)
    file_open_write_v2('log-ap', 'a+', limit)

    Benchmark.bm do |x|
        x.report("Iterate and write per line to existing file, mode \"w\"") { file_open_write_v2('log-w', 'w', limit) }
        x.report("Iterate and write per line to existing file, mode \"a\"") { file_open_write_v2('log-a', 'a', limit) }
        x.report("Iterate and write per line to existing file, mode \"w+\"") { file_open_write_v2('log-wp', 'w+', limit) }
        x.report("Iterate and write per line to existing file, mode \"a+\"") { file_open_write_v2('log-ap', 'a+', limit) }
    end

    delete_file('log-w')
    delete_file('log-a')
    delete_file('log-wp')
    delete_file('log-ap')
end

mem_benchmark_with_new_file
cpu_benchmark_with_new_file
mem_benchmark_with_existing_file
cpu_benchmark_with_existing_file

