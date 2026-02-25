

function performance_monitor()

    local cpu_percentage = 0;
    local max_cpu_percentage = 0;
    local current_time = -1;

    -- add current performance to the performance percentage
    -- reset if at next tick
    function register_load()
        if game_status == "playing" then
            if not(current_time == game_time) then
                cpu_percentage = 0;
                current_time = game_time;
            end

            cpu_percentage += stat(1);
            max_cpu_percentage = max(cpu_percentage, max_cpu_percentage);
        end
    end

    function print_summary()
        max_cpu_percentage = flr(max_cpu_percentage*10)/10;
        print("cpu spike: "..max_cpu_percentage, 150,200);
    end

    function print_current()
        print(stat(7), 218, 103, 11);
    end
    return {
        register_load = register_load,
        print_summary = print_summary,
        print_current = print_current,
    };
end


