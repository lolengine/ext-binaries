// Copyright (c) 2008 Dr. Colin Hirsch
// Please see license.txt for license.

#ifndef COHI_PEGTL_HH
#define COHI_PEGTL_HH

#include <iomanip>
#include <iostream>
#include <iterator>
#include <map>
#include <memory>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

#include <assert.h>
#if !_WIN32 && !EMSCRIPTEN // LOL BEGIN
#include <cxxabi.h>
#endif // LOL END
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#if !_WIN32 // LOL BEGIN
#include <unistd.h>
#endif // LOL END
#include <stdio.h>

#include <sys/stat.h>
#if !_WIN32 // LOL BEGIN
#include <sys/mman.h>
#endif // LOL END
#include <sys/types.h>

#include <pegtl/constants.hh>
#include <pegtl/utilities.hh>

#include <pegtl/input_generic.hh>
#include <pegtl/input_forward.hh>
#include <pegtl/input_buffer.hh>
#include <pegtl/input_string.hh>

#include <pegtl/debug_dummy.hh>
#include <pegtl/debug_count.hh>
#include <pegtl/debug_print.hh>
#include <pegtl/debug_basic.hh>
#include <pegtl/debug_trace.hh>

#include <pegtl/parse_generic.hh>
#include <pegtl/parse_iterator.hh>
#include <pegtl/parse_string.hh>
#include <pegtl/parse_filename.hh>

#include <pegtl/rules_action.hh>
#include <pegtl/rules_basic.hh>
#include <pegtl/rules_extended.hh>
#include <pegtl/rules_special.hh>
#include <pegtl/rules_string.hh>

#endif
