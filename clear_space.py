import re
import sys
def replace_spaces_in_ids(gtf_file):
    # Regular expressions to match transcript_id, gene_id, and gene_name
    transcript_pattern = re.compile(r'transcript_id "([^"]+)"')
    gene_id_pattern = re.compile(r'gene_id "([^"]+)"')
    gene_name_pattern = re.compile(r'gene_name "([^"]+)"')

    # Read the file and replace spaces
    with open(gtf_file, 'r') as infile:
        lines = infile.readlines()

    with open(gtf_file, 'w') as outfile:
        for line in lines:
            # Replace spaces inside transcript_id, gene_id, and gene_name with underscores
            line = re.sub(transcript_pattern, lambda m: f'transcript_id "{m.group(1).replace(" ", "_")}"', line)
            line = re.sub(gene_id_pattern, lambda m: f'gene_id "{m.group(1).replace(" ", "_")}"', line)
            line = re.sub(gene_name_pattern, lambda m: f'gene_name "{m.group(1).replace(" ", "_")}"', line)
            
            outfile.write(line)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python clear_space.py <path_to_gtf_file>")
        sys.exit(1)

    # Read the filename from the first command-line argument
    gtf_file = sys.argv[1]

    # Process the file in-place
    replace_spaces_in_ids(gtf_file)
    print(f"Processed file: {gtf_file}")
