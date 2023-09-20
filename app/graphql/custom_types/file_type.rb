class CustomTypes::FileType < Types::BaseScalar
  description "A valid URL, transported as a string"

  def self.coerce_input(file)
    ActionDispatch::Http::UploadedFile.new(
      filename: file.original_filename,
      type: file.content_type,
      headers: file.headers,
      tempfile: file.tempfile
    )
  end
end

    # {"operations"=>
    # "{\"operationName\":null,
    #  \"variables\":
    #     {\"file\":null},
    #     \"query\":
    #       \"mutation ($file: String) {\\n  
    #           upload(input: {file: $file}) {
    #             \\n    errors
    #             \\n    __typename
    #             \\n  
    #           }
    #     \\n}
    #   \\n\"}", 
    #   "map"=>
    #     "{\"1\":[\"variables.file\"]}", 
    #         "1"=>#<ActionDispatch::Http::UploadedFile:0x00007fe10034f420 
    #         @tempfile=#<Tempfile:/tmp/RackMultipart20230906-108212-1ntmzvb.jpg>,
    #         @original_filename="110763096c591936fff55b3058a98533.jpg",
    #         @content_type="image/jpeg", 
    #         @headers="Content-Disposition: form-data;
    #         name=\"1\";
    #         filename=\"110763096c591936fff55b3058a98533.jpg\"\r
    #         \nContent-Type: image/jpeg\r\n">, 
    #         "operationName"=>nil, 
    #         "variables"=>
    #         {"file"=>
    #         #<ActionDispatch::Http::UploadedFile:0x00007fe10034f420 
    #         @tempfile=#<Tempfile:/tmp/RackMultipart20230906-108212-1ntmzvb.jpg>, 
    #         @original_filename="110763096c591936fff55b3058a98533.jpg",
    #         @content_type="image/jpeg", 
    #         @headers="Content-Disposition: 
    #         form-data; name=\"1\"; 
    #         filename=\"110763096c591936fff55b3058a98533.jpg\"\r
    #         \nContent-Type: image/jpeg\r
    #         \n">}, 
    #         "query"=>"mutation ($file: String) {\n  
    #         upload(input: {file: $file}) 
    #         {\n    errors\n    __typename\n 
    #          }\n}\n"}
