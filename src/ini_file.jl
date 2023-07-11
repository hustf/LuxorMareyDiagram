"""
    get_config_value(sect::String, key::String)

Instead of passing long argument lists, we store visual adaptions in a text file.
"""
function get_config_value(sect::String, key::String)
    fnam = _get_ini_fnam()
    ini = read(Inifile(), fnam)
    if sect ∉ keys(sections(ini))
        throw(ArgumentError("$sect not a section in $fnam. These are: $(keys(sections(ini)))"))
    end
    s = get(ini, sect, key,  "")
    if s == ""
        throw(ArgumentError("""
            $key not a key with value in section $sect of file $fnam. 
           
            Example:
            [user]                          # section  
            user_name     = slartibartfast  # key and value
            perceived_age = 5

            Current file:
            $ini

            We return an empty string
            """))
    end
    s
end


"Get an existing, readable ini file name, create it if necessary"
function _get_ini_fnam()
    fna = joinpath(homedir(), "LuxorMareyDiagram.ini")
    if !isfile(fna)
        open(_prepare_init_file_configuration, fna, "w+")
        if Sys.iswindows()
            run(`cmd /c $fna`; wait = false)
        end
        println("Default settings stored in $fna")
    end
    fna
end

function _prepare_init_file_configuration(io)
    # Add a comment at top (IniFile.jl has no functions for comments)
    msg = """
        # Configuration file for text and visual elements used by 'LuxorMareyDiagram'.
        # You can modify and save the values here. To start over from 'factory settings':
        # Delete this file. A new file will be created next time configurations are used.
        #
        # Some values are given as a mulitiplier of these constants:
        #
        # FS = 37.5
        # Font size FS for Luxor, corresponding to Word points.
        #
        #
        # EM = 44    
        # The unit EM, as in .css, corresponds to text + margins above and below
        #
        #
        # TXTOFFV = 6
        # Text position is given from the baseline, but text extends below that.
        # 
        #
        # PT = 4
        # Line thickness, points
        #
        """
    #
    conta = Inifile()
    set(conta, "Location axis", "Direction along [deg]", 0.0)
    set(conta, "Location axis", "Line width [PT]", 1)
    set(conta, "Location axis", "Arrow head angle [deg]", 15)
    set(conta, "Location axis", "Arrow length [EM]", 1)
    set(conta, "Location axis", "Toy text size [FS]", 1)
    set(conta, "Location axis", "Toy font face", "JuliaMono")
    set(conta, "Location axis", "Pro text size [FS]", 1)
    set(conta, "Location axis", "Pro font face", "JuliaMono")
    set(conta, "Time axis", "Direction along", 1)
    set(conta, "Time axis", "key1", 1)
    println(io, conta)
end
