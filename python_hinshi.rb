#!/usr/bin/env ruby
# coding: utf-8

require_relative 'hinshi'  # hinshi.rb を読み込む

def ruby_to_python(ruby_hash)
  # ハッシュを文字列に変換
  python_dict = ruby_hash.inspect

  # Rubyの特殊な構文を置換
  python_dict.gsub!('=>', ':')
  
  # Rubyのシンボルを文字列に変換
  python_dict.gsub!(/(\w+):/, '"\1":')
  
  # Rubyのnilをpythonのnoneに置換
  python_dict.gsub!('nil', 'None')
  
  # キーをクォートで囲む（まだクォートで囲まれていないもの）
  python_dict.gsub!(/([{,]\s*)(\w+):/) { "#{$1}\"#{$2}\":" }
  
  # $変数をpython_に置換
  python_dict.gsub!(/\$(\w+)/, 'python_\1')

  python_dict
end

# hinshi_fとhinshi_tの構造体を使用
hinshi_f = $hinshi_f
hinshi_t = $hinshi_t

# 変換を実行
python_hinshi_f = ruby_to_python(hinshi_f)
python_hinshi_t = ruby_to_python(hinshi_t)

# 結果を出力
puts "# hinshi.py\n"
puts "hinshi_f = #{python_hinshi_f}"
puts "\n"
puts "hinshi_t = #{python_hinshi_t}"

puts <<~RUBY
def hinshi_hantei(hinsi, from_dic_type="anthy", to_dic_type="mozc"):
    """品詞判定関数"""
    hinsi_code = hinsi[1:]  # 先頭の '#' を除去
    
    try:
        return hinshi_t[to_dic_type][hinshi_f[from_dic_type][hinsi_code]]
    except KeyError:
        return "名詞"  # KeyError の場合は "名詞" を返す

RUBY
