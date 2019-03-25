from cyvcf2 import VCF
import sys

def getBinSize(size):
    if size in range(50):
        return "BIN1: <50bp"
    elif size in range(50, 100):
        return "BIN2: 50-100bp"
    elif size in range(100, 1000):
        return "BIN3: 100-1000bp"
    elif size in range(1000, 10000):
        return "BIN4: 1000-10000bp"
    else:
        return "BIN5: >10000bp"


def getRecord(samples, sampleName, reader, vcf, output):
    with open(output, 'w') as FO:
        header = ",".join(["ID", "SAMPLE", "BINSIZE"] + list(samples))
        FO.write(header+"\n")
        for record in reader:
            id = record.CHROM+str(record.start)
            svtype = record.INFO["SVTYPE"]
            if svtype == "DEL":
                suppvec = record.INFO["SUPP_VEC"]
                size = record.INFO["SVLEN"]
                binsize = getBinSize(abs(int(size)))
                data = ",".join([id, sampleName, binsize] + list(suppvec))
                FO.write(data+"\n")
                # print(data)


if __name__ == '__main__':
    vcf = sys.argv[1]
    sampleName = sys.argv[2]

    outputUpset = sys.argv[3]
    reader = VCF(vcf)
    samples = reader.samples
    getRecord(samples, sampleName, reader, vcf, outputUpset)
