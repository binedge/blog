import NextImage, { ImageProps } from 'next/image'

const Image = ({ src, ...rest }: ImageProps) => <NextImage src={`/blog${src}`} {...rest} />

export default Image
