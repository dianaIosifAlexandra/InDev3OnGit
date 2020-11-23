using System;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.ApplicationFramework
{
    /// <summary>
    /// Used for encrypting sql server information in web.config
    /// </summary>
    public class EncryptingSupport
    {

        public static string Base64EncodeString(string inputString)
        {
            EncryptingSupport hs = new EncryptingSupport();
            return hs.Base64Encode(inputString);
        }

        public static string Base64DecodeString(string inputString)
        {
            EncryptingSupport hs = new EncryptingSupport();
            return hs.Base64Decode(inputString);
        }



        /// <summary>
        /// Hash an input string and return the hash as a 32 character hexadecimal string.
        /// </summary>
        /// <param name="plainPassword">The password in plain text that needs to be hashed</param>
        /// <returns>The hash for the password</returns>
        public string HashPassword(string plainPassword)
        {
            // Create a new instance of the MD5CryptoServiceProvider object.
            MD5 md5Hasher = MD5.Create();

            // Convert the input string to a byte array and compute the hash.
            byte[] data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(plainPassword));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }

        /// <summary>
        /// Encodes a string using Base64
        /// </summary>
        /// <param name="data">The string to be encoded</param>
        /// <returns>The encoded string</returns>
        public string Base64Encode(string data)
        {
            try
            {
                byte[] dataBytes = Encoding.ASCII.GetBytes(data);
                string encodedData = Convert.ToBase64String(dataBytes);
                return encodedData;
            }
            catch (ArgumentException ex)
            {
                throw new IndException(ex);               
            }
        }

        /// <summary>
        /// Decodes a string using Base64
        /// </summary>
        /// <param name="data">The string to be decoded</param>
        /// <returns>The decoded string</returns>
        public string Base64Decode(string data)
        {
            try
            {
                ASCIIEncoding encoder = new ASCIIEncoding();
                Decoder asciiDecoder = encoder.GetDecoder();

                byte[] dataBytes = Convert.FromBase64String(data);
                int charCount = asciiDecoder.GetCharCount(dataBytes, 0, dataBytes.Length);
                char[] decodedChars = new char[charCount];
                asciiDecoder.GetChars(dataBytes, 0, dataBytes.Length, decodedChars, 0);
                string result = new String(decodedChars);
                return result;
            }
            catch (ArgumentException ex)
            {
                throw new IndException(ex);
            }
        }

        public string GetUniqueKey()
        {
            int maxSize = 8;
            char[] chars = new char[62];
            string a;
            a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
            chars = a.ToCharArray();
            int size = maxSize;
            byte[] data = new byte[1];
            RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider();
            crypto.GetNonZeroBytes(data);
            size = maxSize;
            data = new byte[size];
            crypto.GetNonZeroBytes(data);
            StringBuilder result = new StringBuilder(size);
            foreach (byte b in data)
            { result.Append(chars[b % (chars.Length - 1)]); }
            return result.ToString();
        }
    }
}
