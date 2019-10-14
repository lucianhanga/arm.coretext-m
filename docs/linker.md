<a name="table-of-contents"></a>
#### Table of Contents ####




#### 1. Generic ####

**ld** combines a number of object and archive files, relocates their data and ties up symbol references. Usually the last step in compiling a program is to run **ld**.
**ld** accepts Linker Command Language files (**linker scripts**), to provide explicit and total control over the linking process. It controls the following resources:
+ input files
+ file formats
+ output file layout
+ addresses of sections
+ placement of common blocks


#### 2. Linker Scripts ####

The **ld** command language is a collection of statements. The most fundamental command of the ld command language is the **SECTIONS** command. It specifies a image of the output file's layout. Another important command is **MEMORY** and it describes the available memory in the target architecture.

**Location Counter** 
Like in the assembly language there is the variable: dot  '**.**' which always contains the current output location counter.  Since the **dot** refers to the location in the output it should appear always in the **SECTIONS** command. Assigning a value to the **.** symbol will cause the location counter to be moved. This may be used to create holes in the output section. The location counter may **never** be moved backwards.

Example:

```
SECTIONS
{
  output :
  {
  file1(.text)
  . = . + 1000;
  file2(.text)
  . += 1000;
  file3(.text)
  } = 0x1234;
}
```

In the example, *file1* is located at the beginning of the output section,then there is a 1000 byte gap. Then *file2* appears, also with a 1000 byte gap following before *file3* is loaded. The notation `= 0x1234' specifies what data to write in the gaps.

**Expresions**

It is possible to create global symbols, and assign values (addresses) to global symbols, using any of the C assignment operators.

Assignment statements may appear:
+ commands independent in  the **ld** script
+ independent statements within a SECTIONS command
+ as part of the contents of a section definition in a SECTIONS command

The first two cases are equivalent in effect: both define a symbol with an **absolute address**. The last case defines a symbol whose address is **relative** to a particular section. 
When a linker expression is evaluated and assigned to a variable, it is given either an **absolute** or a **relocatable** type. 
+ An **absolute expression type** is one in which the symbol contains the value that it will have in the output file; 
+ A **relocatable expression type** is one in which the value is expressed as a fixed offset from the base of a section.

The type of the expression is controlled by its position in the script file. A symbol assigned **within** a section definition is created **relative** to the base of the section. A symbol assigned outside (or any other place than inside a section) is created as an **absolute** symbol. A symbol may be created with an absolute value even when assigned to within a section definition by using the absolute assignment function **ABSOLUTE**.

Example: Create an **absolute symbol** whose address is the last byte of an output section named .data.
```
SECTIONS{ ...
  .data : 
    {
      *(.data)
      _edata = ABSOLUTE(.) ;
    } 
... }
```

**ABSOLUTE(exp)**
Return the absolute (non-relocatable, as opposed to non-negative) value of the expression exp. Primarily useful to assign an absolute value to a symbol within a section definition, where symbol values are normally section-relative.

**ADDR(section)**
Return the absolute address of the named section. Your script must previously have defined the location of that section.

```
SECTIONS{ ...
  .output1 :
    { 
    start_of_output_1 = ABSOLUTE(.);
    ...
    }
  .output :
    {
    symbol_1 = ADDR(.output1);
    symbol_2 = start_of_output_1;
    }
... }
```

In the example above the **start_of_output_1** symbol even if is defined inside the **.output1** it will containt the address of the **.output1**. The variable **symbol_1** will contain the address of the **.output1** and it will have the same value like **symbol_2** which is assigned to **start_of_output_1** which is an absolute value (see above).

