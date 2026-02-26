

function performance_monitor()

    local cpu_percentage = 0;
    local max_cpu_percentage = 0;
    local min_fps = 60;

    function reset_cpu_load()
        cpu_percentage = 0;
    end

    -- add current performance to the performance percentage
    -- reset if at next tick
    function register_load()
        cpu_percentage += stat(1);
        max_cpu_percentage = max(cpu_percentage, max_cpu_percentage);
    end

    function print_summary()
        info = flr(max_cpu_percentage*100)/100;
        print("cpu spike: "..info, 150, 200);
        print("fps low:   "..min_fps);
    end

    function print_current()
        print(stat(7), 218, 103, 11);
        min_fps = min(stat(7),min_fps);
    end
    return {
        register_load = register_load,
        print_summary = print_summary,
        print_current = print_current,
        reset_cpu_load = reset_cpu_load,
    };
end


