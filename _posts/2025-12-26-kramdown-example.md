---
title: "Kramdown Grammar List"
date: 2025-12-26
section: "tech-bites"
categories: ["markdown", "tips"]
description: "Comprehensive examples of all Kramdown/Markdown syntax supported in this blog."
reading_time: 15
toc : true
---

> Original Paper : [OpenVLA: An Open-Source Vision-Language-Action Model](https://arxiv.org/pdf/2406.09246)
> <br>OpenSource repo : [OpenVLA](https://openvla.github.io/)
{: .reference}

# Headings

# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6

---

# Text Formatting

This is a paragraph with **bold text**, *italic text*, and ***bold italic text***.

You can also use __bold__ and _italic_ with underscores.

This is ~~strikethrough text~~.

Here's some `inline code` within a paragraph.

---

# Blockquotes

> This is a simple blockquote.
> It can span multiple lines.

> This is a nested blockquote example.
> 
> > This is nested inside.
> > > And this is even deeper.

> **Tip**: You can use other markdown syntax inside blockquotes.
> 
> - Including lists
> - And other elements

---

# Lists

## Unordered Lists

- First item
- Second item
- Third item
  - Nested item 1
  - Nested item 2
    - Deeply nested item

* Alternative style with asterisks
* Another item

## Ordered Lists

1. First item
2. Second item
3. Third item
   1. Nested ordered item
   2. Another nested item
4. Fourth item

## Task Lists

- [x] Completed task
- [ ] Incomplete task
- [ ] Another task to do

---

# Code Blocks

## Inline Code

Use `inline code` for short snippets like `variable_name` or `function()`.

## Fenced Code Blocks

### Bash

```bash
brew install --HEAD randomplum/gtkwave/gtkwave
echo "Hello, World!"
cd /path/to/directory
```

### Python

```python
def hello_world():
    """A simple function that prints Hello, World!"""
    print("Hello, World!")
    return True

# Call the function
hello_world()
```

### JavaScript

```javascript
const greet = (name) => {
    console.log(`Hello, ${name}!`);
    return `Greeting sent to ${name}`;
};

greet('World');
```

### Verilog

```verilog
task check_outputs_vectorwise(input integer current_cycle, input integer offset);
    integer row_idx;
    integer start_port;
    integer target_col;
    reg [25:0] golden_val;
    begin
        start_port = current_cycle - 16;
        target_col = current_cycle - 16;

        for (row_idx = 0; row_idx < 16; row_idx = row_idx + 1) begin
            golden_val = mem_ref[offset*256 + (row_idx * 16) + target_col];
            
            if (io_outputC[start_port + row_idx] !== golden_val) begin
                $display("[ERROR] Cycle %d | Col %d, Row %d", 
                        current_cycle, target_col, row_idx);
            end
        end
    end
endtask
```

### Plain Text

```
This is a code block without syntax highlighting.
Just plain text.
```

---

# Links

## Basic Links

[Link text](https://example.com)

[Link with title](https://example.com "This is a title")

## Reference Links

[Reference-style link][reference]

[reference]: https://example.com "Optional title"

## Automatic Links

<https://example.com>

<email@example.com>

---

# Images

## Basic Image

![Alt text](https://via.placeholder.com/400x200 "Image title")

## Image with Link

[![Alt text](https://via.placeholder.com/400x200)](https://example.com)

---

# Tables

## Simple Table

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Row 1    | Data     | More data|
| Row 2    | Data     | More data|
| Row 3    | Data     | More data|

## Aligned Columns

| Left Aligned | Center Aligned | Right Aligned |
|:-------------|:--------------:|--------------:|
| Left         | Center         | Right         |
| Text         | Text           | Text          |
| More         | More           | More          |
{: .no-indent}


## Small Table (Auto Width)

Add `{: .small-table}` after the table to make it fit content instead of full width:

| Item | Qty |
|------|----|
| Apple| 5   |
| Orange| 3  |
{: .small-table}

---

# Horizontal Rules

You can create horizontal rules using:

Three or more hyphens:

---

Three or more asterisks:

***

Three or more underscores:

___

---

# Line Breaks

To create a line break, end a line with two or more spaces,  
or use a backslash at the end of the line.\
Like this.

Alternatively, you can use a blank line to create a new paragraph.

---

# Escaping Characters

You can escape special characters using a backslash:

\* This is not italic \*

\# This is not a heading

\`This is not code\`

---

# Footnotes

Here's a sentence with a footnote[^1].

Here's another with a longer footnote[^longnote].

[^1]: This is the first footnote.

[^longnote]: This is a longer footnote with multiple paragraphs.
    
    You can add more content here.
    
    - Even lists
    - Like this

---

# Abbreviations

The HTML specification is maintained by the W3C.

*[HTML]: Hyper Text Markup Language
*[W3C]: World Wide Web Consortium

---

# Definition Lists

Term 1
: Definition 1

Term 2
: Definition 2a
: Definition 2b

---

# Math (if supported)

Inline math: $E = mc^2$

Block math:

$$
\frac{n!}{k!(n-k)!} = \binom{n}{k}
$$

---

# HTML Elements

You can use HTML directly in Kramdown:

<div style="color: blue;">
This text is blue using inline HTML.
</div>

<details>
<summary>Click to expand</summary>

This content is hidden until you click the summary.

</details>

---

# Special Kramdown Features

## Attribute Lists

This is a paragraph with an ID and class.
{: #para-id .my-class}

## Block Attributes

{: .important}
> This blockquote has a class attribute.

---

# Complex Example

Here's a complex example combining multiple elements:

## Project Setup

1. **Install dependencies**
   
   ```bash
   npm install
   # or
   yarn install
   ```

2. **Configure environment**
   
   Create a `.env` file:
   
   ```env
   API_KEY=your_api_key_here
   DATABASE_URL=postgresql://localhost:5432/mydb
   ```

3. **Run the application**
   
   ```bash
   npm run dev
   ```

> **Note**: Make sure you have Node.js version 18+ installed.

### Features

| Feature | Status | Notes |
|---------|--------|-------|
| Authentication | ✅ | OAuth 2.0 |
| Database | ✅ | PostgreSQL |
| Caching | 🚧 | In progress |
| Testing | ❌ | Not started |

---

# Conclusion

This document demonstrates all the major Kramdown/Markdown syntax supported in this blog. Feel free to use this as a reference when writing your posts!

**Happy writing!** 🎉
