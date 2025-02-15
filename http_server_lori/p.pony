use "debug"

primitive P
  fun apply(s: Pointer[U8] tag) =>
    @printf(s)

  fun debug(t: String val, loc: SourceLoc = __loc) =>
    Debug.out("[" + @pony_scheduler_index().string() + "]: " + t + ": " + loc.type_name() + ": " + loc.method_name() + ": " + loc.line().string())

